source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'bootstrap_form', '~> 0.3.2'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'figaro'
gem 'sidekiq'
gem 'redis'
gem 'unicorn'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'
gem 'stripe_event'
gem 'draper', '~> 1.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock', '1.11.0'
  gem 'selenium-webdriver'
  gem 'database_cleaner', '<1.1.0'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'letter_opener'
  gem 'faker'
  gem 'pry'
end

group :production do
  gem 'pg'
end