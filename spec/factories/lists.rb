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

FactoryGirl.define do
  factory :list, class: 'List' do
    title Faker::Name.title
  end
end
