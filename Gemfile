source 'https://rubygems.org'

gem 'berkshelf'
gem 'thor-foodcritic'

group :test do
  gem "chefspec"
  gem "foodcritic"
  gem "guard"
  gem "guard-rspec"
  gem "guard-kitchen"
  gem "ruby_gntp"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end
gem "test-kitchen", git: 'git://github.com/opscode/test-kitchen.git', :group => :integration
gem 'kitchen-vagrant', git: 'git://github.com/opscode/kitchen-vagrant.git', branch: 'master', :group => :integration
