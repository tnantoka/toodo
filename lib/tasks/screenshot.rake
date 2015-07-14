task 'screenshot': :environment do
  ActiveRecord::Base.transaction do
    user = User.first
    user.lists.destroy_all

    user.lists.create!(
      title: 'TooDo Dev',
      content: <<-EOD.strip_heredoc
        - [x] Paper prototyping
        - [x] GitHub integration
          - [x] Sign in
          - [x] Sync to Gist
        - [x] react-rails
        - [x] Ad
        - [ ] Release
          - [x] Ansible
          - [ ] Deploy
          - [ ] Blogging
      EOD
    )

    user.lists.create!(
      title: 'Personal',
      content: <<-EOD.strip_heredoc
        - [x] Pay electricity bill
        - [ ] Book flight to Japan
      EOD
    )

    user.lists.create!(
      title: 'Today',
      content: <<-EOD.strip_heredoc
        - [x] Pick up the milk
        - [ ] Return library books
        - [ ] Take out the trash
      EOD
    )

    user.lists.create!(
      title: 'Study',
      content: <<-EOD.strip_heredoc
      EOD
    )
  end
end
