#!/usr/bin/env rake
require 'rspec/core/rake_task'
require 'foodcritic'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
desc 'Runs rspec tests'
task :test => :spec

desc 'Runs foodcritic linter'
task :foodcritic do
  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    FoodCritic::Rake::LintTask.new do |t|
      t.options = { :fail_tags => ['any'] }
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc 'Runs Rubocop against the cookbook.'
task :rubocop do
  Rubocop::RakeTask.new
end

# Rubocop before rspec so we don't lint vendored cookbooks
task :default => %w{rubocop foodcritic test}
