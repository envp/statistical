require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

# Add a cop task for code linting
RuboCop::RakeTask.new(:cop) do |task|
  task.options = ['--format', 'simple']
end

task :default => :spec
