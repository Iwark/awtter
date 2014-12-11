source 'https://rubygems.org'

gem 'rails', '4.1.5'
gem 'slim-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'jquery-rails'
gem 'jquery-ui-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'nprogress-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bootstrap-sass'
gem 'unicorn'
gem 'whenever', :require => false
gem 'settingslogic'
gem 'twitter'
gem 'kaminari'
gem "acts-as-taggable-on"
gem "asset_sync"

group :development do
  gem 'sqlite3'
  gem 'spring'
  gem 'better_errors'
  gem 'annotate'
  gem "capistrano"
  gem "capistrano-rails"
  gem "capistrano-bundler"
  gem "capistrano-rbenv"
  gem "capistrano3-unicorn"
  gem "bullet"
  # gem 'rack-mini-profiler'
end

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  gem 'rb-fsevent'
end

group :test do
  gem 'shoulda-matchers'
end