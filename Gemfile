source "https://rubygems.org"

  gem "berkshelf"
  gem "thor-foodcritic"

group :test do
  gem "rake"
  gem "chefspec"
  gem "foodcritic"
  gem "tailor"
end

group :development do
  gem "guard"
  gem "guard-rspec"
  gem "guard-kitchen"
  gem "ruby_gntp"
  gem "rb-inotify"
  gem "rb-fsevent"
  gem "rb-fchange"
end

gem "test-kitchen", "~> 1.0.0.beta.3",:group => :development
gem "kitchen-vagrant", "~> 0.11", :group => :development
