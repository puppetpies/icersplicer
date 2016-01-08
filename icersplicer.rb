########################################################################
#
# Author: Brian Hood
# Name: Icersplicer
#
# Description: 
#   Text processing with power with very minimal mruby for performance
#   that only has a File class extension mruby-io
#
# Why: for processing large datasets quickly.
########################################################################
require 'getoptlong'
require 'pp'

def text_highlighter(text)
  keys = ["Ln:", "SELECT", "CREATE TABLE", "UPDATE", "DELETE", "INSERT", "FROM", "OFFSET", "GROUP BY", "HAVING", "ORDER BY",
          "ALTER USER", "ALTER TABLE", "COPY", "INTO", "VALUES", "DELIMITERS", "STDIN", "CREATE USER", "WITH", "USING",
          "CREATE INDEX", "CONSTRAINT", "ALTER INDEX", "INTEGER", "CHAR", "CLOB", "VARCHAR", "STRING", "DEFAULT", "NULL", "NOT",
          "RECORDS", "KEY", "PRIMARY", "FOREIGN", "BIGINT", "MERGE", "REMOTE", "DROP TABLE", "SET SCHEMA", "CREATE SCHEMA",
          "ALTER SCHEMA", "ADD", "TABLE", "CREATE SEQUENCE", "ALTER SEQUENCE"]
  cpicker = [2,3,4,1,7,5,6] # Just a selection of colours
  keys.each {|n|
    text.gsub!("#{n}", "\e[4;3#{cpicker[rand(cpicker.size)]}m#{n}\e[0m\ \e[0;32m".strip)
  }
  return text
end

ARGV[0] = "--help" if ARGV[0] == nil

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--lineoffset', '-l', GetoptLong::REQUIRED_ARGUMENT],
  [ '--linelimit', '-n', GetoptLong::REQUIRED_ARGUMENT],
  [ '--incrementlimit', '-p', GetoptLong::REQUIRED_ARGUMENT],
  [ '--inputfile', '-i', GetoptLong::REQUIRED_ARGUMENT],
  [ '--skiplines', '-s', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--quiet', '-q', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--outputfile', '-o', GetoptLong::NO_ARGUMENT]
)

opts.each do |opt, arg|
  case opt
    when '--help'
      helper = "\e[1;34mWelcome to Icersplicer\e[0m\ \n"
      helper << "\e[1;34m=====================\e[0m\ \n"
      helper << %q[
-h, --help:
   show help

Example:
      
      ruby icersplicer.rb -i inputfile --lineoffset 0 --linelimit 10 --incrementlimit 0 -s 3,6,9 -o outputfile 
      
      ]
      puts helper
      exit
    when '--lineoffset'
      @line_offset = arg.to_i
    when '--linelimit'
      @line_limit = arg.to_i
    when '--incrementlimit'
      @increment_limit = arg.to_i
    when '--inputfile'
      @inputfile = arg.to_s
    when '--outputfile'
      @outputfile = arg.to_s
    when '--skiplines'
      @skip_lines = Array.new
      arg.to_s.split(",").each {|n| @skip_lines << n.to_i }
    when '--quiet'
      if arg == "true"
        @quiet_mode = true
      else
        @quiet_mode = false
      end
  end
end

lineoffset = @line_offset
linelimit = @line_limit
increment_offset = 0
increment_limit = @increment_limit
linecounter = 0
quietmode = false | @quiet_mode

inputfile = @inputfile
outputfile = @outputfile

=begin
def skip(line)
  puts "Lines: #{line}"
  line_element = @skip_lines.index(line)
  puts "Element ID: #{line_element}"
  if line_element != nil
    skiper = @skip_lines[line_element]
    puts "Skiper: #{skiper} Line element: #{line_element}"
    @skip_lines.delete_at(line_element)
  end
  return skiper
end
=end

def skip(line)
  begin
    #puts "Lines: #{line}"
    line_element = @skip_lines.index(line)
    #puts "Element ID: #{line_element}"
    if line_element != nil
      skiper = @skip_lines[line_element]
      #puts "Skiper: #{skiper} Line element: #{line_element}"
      @skip_lines.delete_at(line_element)
    end
  rescue NoMethodError
    return nil
  end
  return skiper
end

def print_to_screen(linenum, text, quiet)
  puts "\e[1;33mLn: #{linenum}:\e[0m\ #{text}" unless quiet == true
end

def checkoutputfile?
  if File.exists?("#{@outputfile}")
    return false
  else
    openfile unless instance_variable_defined?("@exp")
    return true
  end
end

def openfile
  puts "Openfile: #{@outputfile}"
  @exp = File.open("#{@outputfile}", 'w')
end

def writefile(data)
  @exp.write(data)
end

def closefile
  @exp.close
  puts "Closing file: #{@outputfile}"
end

def processdata(data, quietmode)
    if checkoutputfile?
      writefile(data)
    else
      puts "File already exists..."
    end
end

File.open(inputfile) {|n|
  n.each_line {|data|
    unless lineoffset > increment_offset
      unless linelimit == 0
        unless increment_limit > linelimit
          print_to_screen(linecounter, text_highlighter(data), quietmode) unless skip(linecounter)
          processdata(data, quietmode) if instance_variable_defined?("@outputfile")
        end
      else
        print_to_screen(linecounter, text_highlighter(data), quietmode) unless skip(linecounter)
        processdata(data, quietmode) if instance_variable_defined?("@outputfile")
      end
      increment_limit += 1
    end
    increment_offset += 1
    linecounter += 1
  }
}

closefile if instance_variable_defined?("@exp")
