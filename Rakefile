require './lib/icersplicer.rb'

VERSION = Icersplicer::VERSION::STRING

Gem::Specification.new do |s|
  s.name        = 'icersplicer'
  s.version     = VERSION
  s.date        = '2016-01-27'
  s.summary     = "Icersplicer"
  s.description = "Text file manipulation similar to UNIX tools like cat / head / tail"
  s.authors     = ["Brian Hood"]
  s.email       = 'brianh6854@googlemail.com'
  s.files       = ["bin/icersplicer", "lib/icersplicer.rb", "lib/version.rb", "examples/keywords.ice", "examples/files/example_data.sql", "examples/files/voc_dump.sql"]
  s.executables = ["icersplicer"]
  s.homepage    =
    'https://github.com/puppetpies/icersplicer'
  s.license       = 'GPLv2'
  
  s.add_runtime_dependency "walltime", "~> 0.0.5"
  s.add_runtime_dependency "file-tail", "~> 1.1.0"
end

require 'rubygems/tasks'
Gem::Tasks.new
task :build do
  Rake::Task['gem'].invoke
end

# Override standard release task
require 'git'
Rake::Task["release"].clear
task :release do
  version = "#{VERSION}"
  remote = 'origin'
  puts "Creating tag v#{version}"
  git = Git.open(".")
  git.add_tag("v#{version}")
  puts "Pushing tag to #{remote}"
  git.push(remote, 'master', true)
  Rake::Task['gem'].invoke
  gemtask = Gem::Tasks::Push.new
  gemtask.push("pkg/icersplicer-#{version}.gem")
end
