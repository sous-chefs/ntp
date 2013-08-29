source "https://rubygems.org"

gem "berkshelf"
gem "thor-foodcritic"

group :test do
  gem "rake"
  gem "chefspec"
  gem "foodcritic"
  gem "guard"
  gem "guard-rspec"
  gem "guard-kitchen"
  gem "ruby_gntp"
  gem "rb-inotify"
  gem "rb-fsevent"
  gem "rb-fchange"
end
gem "test-kitchen", git: 'git://github.com/opscode/test-kitchen.git', :group => :integration
gem 'kitchen-vagrant', git: 'git://github.com/opscode/kitchen-vagrant.git', branch: 'master', :group => :integration
