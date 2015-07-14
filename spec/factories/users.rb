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

FactoryGirl.define do
  factory :user, class: 'User' do
    nickname Faker::Name.name
    username Faker::Internet.user_name
    token Faker::Lorem.characters(40)
    image Faker::Avatar.image
  end
end
