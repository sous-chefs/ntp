require 'chefspec'
require 'berkshelf'

berks = Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')

# Without this line, berks will infinitely nest vendor/cookbooks/ntp on each rspec run
# https://github.com/RiotGames/berkshelf/issues/828
require 'fileutils'
RSpec.configure do |c|
  c.after(:suite) do
    FileUtils.rm_rf('vendor/')
  end
end
