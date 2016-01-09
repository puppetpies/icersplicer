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
  [ '--incrementlimit', '-i', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--inputfile', '-f', GetoptLong::REQUIRED_ARGUMENT],
  [ '--skiplines', '-s', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--quiet', '-q', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--outputfile', '-o', GetoptLong::OPTIONAL_ARGUMENT],
  [ '--countlines', '-c', GetoptLong::OPTIONAL_ARGUMENT]
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
      
      ruby icersplicer.rb -i inputfile --lineoffset 0 --linelimit 10 -s 3,6,9 -o outputfile 
      
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
    when '--countlines'
      @countlines = true
  end
end

lineoffset = @line_offset
unless instance_variable_defined?("@line_limit") 
  linelimit = 0
else
  linelimit = @line_limit
end
increment_offset = 0
unless instance_variable_defined?("@increment_limit")
  increment_limit = 1
else
  increment_limit = @increment_limit
end
linecounter = 0
quietmode = false | @quiet_mode

inputfile = @inputfile
@nfile = 0

def countlines(inputfile)
  lines = 0
  File.open(inputfile) {|n|
    n.each_line {
      lines += 1
    }
  }
  puts "Filename: #{inputfile} Total Line Count: #{lines}"
end

if @countlines == true
  countlines(inputfile)
  exit
end

def skip(line)
  begin
    line_element = @skip_lines.index(line)
    if line_element != nil
      skiper = @skip_lines[line_element]
    end
  rescue NoMethodError
    return nil
  end
  return skiper
end

def print_to_screen(linenum, text, quiet)
  puts "\e[1;33mLn: #{linenum}:\e[0m\ #{text}" unless quiet == true
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
  openfile if @nfile == 0
  writefile(data)
  @nfile += 1
end

def stats(inputfile)
  print "Inputfile lines: "
  countlines(inputfile)
  print "Outputfile lines: "
  countlines(@outputfile)
end

unless File.exist?("#{inputfile}")
  puts "Input filename / location doesn't exist... ?"
  exit
end

begin
  File.open(inputfile) {|n|
    n.each_line {|data|
      data_orig = data.clone
      unless lineoffset > increment_offset
        unless linelimit == 0
          unless increment_limit > linelimit
            print_to_screen(linecounter, text_highlighter(data), quietmode) unless skip(linecounter)
            processdata(data_orig, quietmode) unless skip(linecounter)
          end
        else
          print_to_screen(linecounter, text_highlighter(data), quietmode) unless skip(linecounter)
          processdata(data_orig, quietmode) unless skip(linecounter)
        end
        increment_limit += 1
      end
      increment_offset += 1
      linecounter += 1
    }
  }
rescue NoMethodError
  puts "Welcome to Icersplicer"
  puts "_-_-_-_-_-_-_-_-_-_-_-|\n\n"
  puts "Requires -f inputfile --lineoffset 0 --linelimit 0"
  puts "Linelimit set to 0 is the whole file -o outputfile optional\n\n"
  puts "Usage: icersplicer.rb -f voc_dump.sql --lineoffset 0 --linelimit 60 -o voctest.sql"
end

closefile if instance_variable_defined?("@exp")
stats(inputfile)
