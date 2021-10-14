source 'http://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Ruby & friends
ruby '2.6.6'
gem 'irb', require: false
gem 'rack'
gem 'rake'
gem 'rspec'

# Rails
gem 'activerecord', '5.2.3', require: 'active_record'
gem 'activesupport', require: 'active_support/all'

# Database
gem 'mysql2'

# Sinatra & friends
gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-flash', '0.3.0', require: 'sinatra/flash'
gem 'puma'
gem 'warden'
gem 'bcrypt'
gem 'require_all', '1.5.0'

# HTTP
gem 'rest-client'

# Heroku
gem 'rails_autoscale_agent', require: 'rails_autoscale_agent/middleware'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '~> 2.13'
  # gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end
