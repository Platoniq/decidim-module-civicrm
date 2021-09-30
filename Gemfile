# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.24.3"

gem "decidim", git: "https://github.com/decidim/decidim", branch: "release/0.24-stable"
gem "decidim-civicrm", path: "."

gem "bootsnap", "~> 1.4"

gem "faker", "~> 2.14"

gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "rubocop-faker", "~> 1.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
