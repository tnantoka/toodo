source 'https://rubygems.org'

gem 'bundler', '>= 1.10.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'capistrano-rbenv'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn'
  gem 'capistrano-passenger'
end

group :test do
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webmock'
  gem 'codeclimate-test-reporter', require: nil
end

group :production do
  gem 'rb-readline'
  gem 'exception_notification'
  gem 'unicorn'
  gem 'newrelic_rpm'
end

gem 'slim-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'octicons-rails'

gem 'rails-i18n'
gem 'dotenv-rails'
gem 'omniauth-github'
gem 'react-rails'
gem 'i18n-js', '>= 3.0.0.rc11'
gem 'octokit'
gem 'sucker_punch'
 
source 'https://rails-assets.org' do
  gem 'rails-assets-autosize'
end
