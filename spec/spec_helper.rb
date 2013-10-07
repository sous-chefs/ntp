require 'chefspec'
require 'berkshelf'

Berkshelf.ui.mute do
  Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')
end

RSpec.configure do |c|
  c.after(:suite) do
    # Berks will infinitely nest vendor/cookbooks/ntp on each rspec run
    # https://github.com/RiotGames/berkshelf/issues/828
    FileUtils.rm_rf('vendor/')
  end
end
