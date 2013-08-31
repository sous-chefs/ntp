#!/usr/bin/env rake
require 'tailor/rake_task'
require 'rspec/core/rake_task'
require 'foodcritic'

RSpec::Core::RakeTask.new(:spec)
desc "Runs rspec tests"
task :test => :spec

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    FoodCritic::Rake::LintTask.new do |t|
      t.options = {:fail_tags => ['any']}
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc "Runs tailor against the cookbook."
task :tailor do
  Tailor::RakeTask.new
end

# Tailor before rspec so we don't tailor vendored cookbooks
task :default => ['tailor', 'test', 'foodcritic']
