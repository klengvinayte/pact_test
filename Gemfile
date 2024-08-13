# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.3'

gem 'active_interaction', '~> 5.3'
gem 'bootsnap', require: false
gem 'dotenv-rails', groups: %i[development test]
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.4'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3'
gem 'redis', '>= 4.0.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'capybara'
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'selenium-webdriver'
end
