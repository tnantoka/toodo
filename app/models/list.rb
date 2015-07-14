# == Schema Information
#
# Table name: lists
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  content    :text(16777215)
#  slug       :string(255)      not null
#  gist       :boolean          default(FALSE), not null
#  gist_id    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_lists_on_slug               (slug) UNIQUE
#  index_lists_on_title_and_user_id  (title,user_id) UNIQUE
#  index_lists_on_updated_at         (updated_at)
#  index_lists_on_user_id            (user_id)
#

class List < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }

  before_save :set_slug, if: 'slug.blank?'
  before_update :set_gist_id, if: 'gist? && gist_id.blank?'
  after_commit :sync_to_gist, if: 'gist? && gist_id.present?'

  scope :recent, -> { order(updated_at: :desc) }

  def to_param
    slug
  end

  def remains
    @remains ||= content.to_s.scan(/\[ \]/).count
  end

  def perform_sync
    client.edit_gist(gist_id, gist_options)
  end

  private
    def set_slug
      begin
        slug = SecureRandom.urlsafe_base64(10)
      end while self.class.exists?(slug: slug)
      self.slug = slug
    end

    def set_gist_id
      gist = client.create_gist(gist_options)
      self.gist_id = gist.id
    end

    def gist_options
      content = self.content.presence || '-'
      {
        description: title,
        files: {
          'toodo.md': { content: content }
        }
      }
    end

    def sync_to_gist
      SyncJob.perform_later(id)
    end

    def client
      Octokit::Client.new(access_token: user.token)
    end
end
