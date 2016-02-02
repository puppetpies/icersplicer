require './lib/icersplicer.rb'
require './lib/version.rb'

VERSION = Icersplicer::VERSION::STRING

Gem::Specification.new do |s|
  s.name        = 'icersplicer'
  s.version     = VERSION
  s.date        = '2016-01-31'
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
end
