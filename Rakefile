require './lib/icersplicer.rb'
require './lib/version.rb'

VERSION = Icersplicer::VERSION::STRING

Gem::Specification.new do |s|
  s.name        = 'icersplicer'
  s.version     = VERSION
  s.date        = '2016-02-03'
  s.summary     = "Icersplicer"
  s.description = "Text file manipulation similar to UNIX tools like cat / head / tail"
  s.authors     = ["Brian Hood"]
  s.email       = 'brianh6854@googlemail.com'
  s.files       = ["bin/icersplicer", "lib/icersplicer.rb", "lib/globutils.rb", "lib/version.rb", "examples/keywords.ice", 
                   "examples/keywords-ruby.ice", "examples/files/example_data.sql", "examples/files/voc_dump.sql"]
  s.executables = ["icersplicer"]
  s.homepage    =
    'https://github.com/puppetpies/icersplicer'
  s.license       = 'BSD'
  
  s.add_runtime_dependency "walltime", "~> 0.0.5"
  s.add_runtime_dependency "file-tail", "~> 1.1.0"
  s.add_runtime_dependency "rainbow", "~> 2.1.0"
end

require 'rubygems/tasks'
Gem::Tasks.new
task :build do
  Rake::Task['gem'].invoke
end

# Override standard release task
require 'git'

task :stage do
  version = "#{VERSION}"
  remote = 'origin'
  git = Git.open(".")
  git.push(remote, 'stage', true)
end

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
