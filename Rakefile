require 'rake'
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Build the gemfile"
task :build do
  sh "gem build five_mobile_push.gemspec"
end
task :gem => :build
