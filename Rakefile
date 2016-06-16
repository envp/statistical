require 'bundler'

Bundler.setup

require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'statistical/version'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

# Add a cop task for code linting
RuboCop::RakeTask.new(:cop) do |t|
  t.options = ['--format', 'simple']
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = ['lib/**/*.rb']
end

# Build the gem
task :build do
  system "gem build statistical.gemspec"
end

# Install gem locally
task :install => :build do
  system "gem install statistical-#{Statistical::VERSION}.gem"
end

# Release gem to github
task :release => :build do
  system "git tag -a v#{Statistical::VERSION} -m 'Version #{Statistical::VERSION}'"
  system "git push --tags"
  system "gem push statistical-#{Statistical::VERSION}.gem"
end

task :default => :spec

task :gem => :build
