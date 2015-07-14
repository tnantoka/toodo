# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string(255)      not null
#  image      :text(65535)
#  username   :string(255)      not null
#  token      :string(255)      not null
#  gist       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_nickname  (nickname) UNIQUE
#

class User < ActiveRecord::Base
  has_one :identity, dependent: :destroy
  has_many :lists, dependent: :destroy

  validates :nickname, presence: true, uniqueness: { case_sensitive: false }

  class << self
    def find_or_create_with_identity!(identity)
      raw = identity.raw
      info = raw.info
      user = identity.user.presence || new(nickname: info.name) 
      user.username = info.nickname
      user.image = info.image
      user.token = raw.credentials.token
      user.save!
      identity.update!(user: user)
      user
    end
  end

  def avatar(size)
    "#{image}&s=#{size}"
  end

  def rate_limit
    @rate_limit ||= client.rate_limit
  end

  private
    def client
      Octokit::Client.new(access_token: token)
    end
end
