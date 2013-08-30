require 'chefspec'
require 'berkshelf'
require 'tmpdir'
require 'fileutils'

berks = Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')

RSpec.configure do |c|
  c.after(:suite) do
    FileUtils.rm_rf('vendor/')
  end
end
