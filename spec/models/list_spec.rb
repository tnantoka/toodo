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

require 'rails_helper'

RSpec.describe List, type: :model do
  let(:list) { create(:list) }

  describe 'validations' do
    subject { list }
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).scoped_to(:user_id).case_insensitive }
  end

  describe 'emoji' do
    it 'does not raise error' do
      expect {
        list.update!(content: '😊') 
      }.to_not raise_error
    end
  end

  describe '#set_slug' do
    it 'sets slug' do
      expect(list.slug).to be_present
    end
  end

  describe '#remains' do
    let(:list) { create(:list, content: '- [ ] task') }
    it 'returns incompleted tasks' do
      expect(list.remains).to eq(1)
    end
  end

  describe '#set_gist_id' do
    let(:user) { create(:user) }
    let(:list) { create(:list, content: '', user: user) }
    before do
      stub_request(:post, 'https://api.github.com/gists').
        to_return(status: 200, body: { id: 'id' }.to_json, headers: { 'Content-Type': 'application/json' })
      list.update!(gist: true)
    end
    it 'sets gist_id' do
      expect(list.gist_id).to_not eq(nil)
    end
  end
end
