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

require 'rails_helper'

RSpec.describe Identity, type: :model do
  let(:identity) { Identity.find_or_create_with_auth_hash!(auth_hash) }

  describe 'validations' do
    subject { identity }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
    it { should validate_presence_of(:provider) }
  end

  describe '::find_or_create_with_auth_hash' do
    it 'creates identity with auth_hash' do
      expect(identity.uid).to eq(auth_hash.uid)
      expect(identity.provider).to eq(auth_hash.provider)
    end
  end
end
