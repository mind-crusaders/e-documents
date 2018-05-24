source 'https://rubygems.org'
ruby '2.5.0'

# Web API
gem 'roda'
gem 'puma'
gem 'json'

# Configuration
gem 'econfig'
gem 'rake'
gem 'pry'

# Security
gem 'rbnacl-libsodium'

# Database
gem 'sequel'
gem 'hirb'
group :development, :test do
  gem 'sqlite3'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
end

# Development
group :development do
  gem 'rubocop'
end

# Production
group :production do
  gem 'pg'
end 

group :development, :test do
  gem 'rerun'
end
