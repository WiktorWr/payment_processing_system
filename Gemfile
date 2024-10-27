# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", require: false
gem "byebug"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.2.1", ">= 7.2.1.2"
gem "sprockets-rails"
gem "stimulus-rails"
gem "stripe", "~> 13.0"
gem "turbo-rails"

group :development, :test do
  gem "brakeman", require: false
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "annotate"
  gem "relaxed-rubocop"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "stripe-ruby-mock"
  gem "webmock"
end
