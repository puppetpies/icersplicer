require './lib/icersplicer.rb'

VERSION = Icersplicer::VERSION::STRING

Gem::Specification.new do |s|
  s.name        = 'icersplicer'
  s.version     = VERSION
  s.date        = '2016-01-17'
  s.summary     = "Icersplicer"
  s.description = "Text file manipulation similar to UNIX tools like cat / head / tail"
  s.authors     = ["Brian Hood"]
  s.email       = 'brianh6854@googlemail.com'
  s.files       = ["bin/icersplicer", "lib/icersplicer.rb"]
  s.executables = ["icersplicer"]
  s.homepage    =
    'https://github.com/puppetpies/icersplicer'
  s.license       = 'GPLv2'
end
