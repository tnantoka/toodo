# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  uid        :string(255)      not null
#  provider   :string(255)      not null
#  raw        :text(65535)      not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_identities_on_uid_and_provider  (uid,provider) UNIQUE
#  index_identities_on_user_id           (user_id)
#

class Identity < ActiveRecord::Base
  belongs_to :user

  serialize :raw

  validates :uid, presence: true, uniqueness: { case_sensitive: false, scope: :provider }
  validates :provider, presence: true

  class << self
    def find_or_create_with_auth_hash!(auth_hash)
      identity = find_or_initialize_by(uid: auth_hash.uid, provider: auth_hash.provider)
      identity.raw = auth_hash
      identity.save!
      identity
    end
  end
end
