source 'http://rubygems.org'

gem 'berkshelf',  '~> 2.0'
gem 'chefspec',   '~> 2.0'
gem 'foodcritic', '~> 2.2'
gem 'rubocop',    '~> 0.12'

group :integration do
  gem 'test-kitchen',    '~> 1.0.0.beta'
  gem 'kitchen-vagrant', '~> 0.11'
end

# Excluded in Travis-CI builds
group :development do
  gem "guard", "~> 1.8"
  gem "guard-kitchen", "~> 0.0"
  gem "guard-rspec", "~> 3.0"
  gem "rb-fchange", "~> 0.0"
  gem "rb-fsevent", "~> 0.9"
  gem "rb-inotify", "~> 0.9"
  gem "ruby_gntp", "~> 0.3"
end
