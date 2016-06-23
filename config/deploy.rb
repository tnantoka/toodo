# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'toodo'
set :repo_url, 'git@github.com:tnantoka/toodo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ENV['DEPLOY_TO']

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('.env', 'config/newrelic.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

if ENV['RVM'].nil?
  set :rbenv_type, :user
  set :rbenv_ruby, '2.2.3'
else
  set :rvm_type, :user
  set :rvm_ruby_version, '2.2.3'
end

if ENV['PASSENGER'].nil?
  set :unicorn_config_path, "#{current_path}/config/unicorn.rb"

  after 'deploy:publishing', 'deploy:restart'
  namespace :deploy do
    task :restart do
      invoke 'unicorn:restart'
    end
  end
else
  set :passenger_restart_with_touch, true
end

namespace :db do
  task :create do
    on roles(:db) do |host|
      within capture("ls -d #{releases_path}/* | tail -1") do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
  task :drop do
    on roles(:db) do |host|
      within capture("ls -d #{releases_path}/* | tail -1") do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, 'db:drop'
        end
      end
    end
  end
end

