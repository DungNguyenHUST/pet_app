source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.1'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
# heroku
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem 'capistrano',         require: false
  # gem 'capistrano-rvm',     require: false
  # gem 'capistrano-rails',   require: false
  # gem 'capistrano-bundler', require: false
  # gem 'capistrano3-puma',   require: false  
  # gem 'capistrano-passenger', '~> 0.2.0'
  # gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#login pass encrypt
gem "bcrypt" 

# add bootstrap
gem "bootstrap-sass", ">= 3.4.1"

# For editor in post
gem 'ckeditor'
gem "twitter-bootstrap-rails"

# For resize image
gem 'image_processing'

#deploy
gem 'capistrano', '>= 3.11'
gem 'capistrano-rails', '~> 1.4'
gem 'capistrano-passenger', '~> 0.2.0'
gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'

gem 'net-ssh', '>= 6.0.2'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

# gem 'puma'

gem 'sitemap_generator'

gem "rails_autolink"

gem 'friendly_id', '~> 5.4.0'

# gem 'google-cloud-storage'

gem 'carrierwave', '2.0.0'
gem 'mini_magick'

# gem "mimemagic"

# gem "fog-google"

gem 'jquery-rails'

# gem 'meta-tags'

# for user login
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-rails_csrf_protection'

# pagenigation
gem 'kaminari'

# scrap data
gem 'httparty'
gem 'nokogiri'
gem 'csv'

# job
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-scheduler'