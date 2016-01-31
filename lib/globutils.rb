require 'pp'

module GlobUtils

=begin

Glob Example

filenames = "/home/brian/Projects/icersplicer/bin/icersplicer,/home/brian/Projects/icersplicer/lib/version.rb,/home/brian/Projects/threatmonitor/*.rb,/home/brian/Projects/Walltime/*"
files =  buildfilelist(filenames)

=end

  FILE_EXT_REGEXP = /\/*.([a-z]|[A-Z])+$/
  FILE_WILDCARD_REGEXP = /\*.([a-z]|[A-Z])+$/

  def glob(f)
    puts "String end: #{f[f.size - 1]}"
    unless f[f.size - 1] == "*"
      files = Hash.new
      globcounter = 0
      fileext = f.split(".")[f.split(".").size - 1] # Extract Extension from string for example .rb
      fileglob = f.gsub(FILE_EXT_REGEXP, "/**/*.#{fileext}").gsub("/*/", "/") # Match to find anything file extension / replace Glob using fileext
      begin
        # Send created glob into Dir.glob
        Dir.glob(fileglob) {|n|
          files.update({globcounter => n})
          globcounter += 1
        }
      rescue 
        raise ArgumentError, "Invalid Glob" 
      end
      return files
    else
      raise ArgumentError, "Please specify file extension for glob i.e *.html"
    end
  end

  def buildfilelist(inputfile)
    rollfiles = Hash.new
    rollcounter = 0
    inputfile.split(",").each {|f|
      puts "Filename: #{f}"
      unless f =~ FILE_WILDCARD_REGEXP
        rollfiles.update({rollcounter => f})
        rollcounter += 1
        puts "Regular File"
      else
        puts "Glob File Mask"
        g = glob(f)
        g.each {|n|
          rollfiles.update({rollcounter => n[1]})
          rollcounter += 1
        }
      end
    }
    return rollfiles
  end

end
