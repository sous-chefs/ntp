require 'chefspec'
require 'berkshelf'
require 'tmpdir'
require 'fileutils'

berks = Berkshelf::Berksfile.from_file('Berksfile').install(path: 'vendor/cookbooks/')
