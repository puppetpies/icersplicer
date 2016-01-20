########################################################################
#
# Author: Brian Hood
# Name: Icersplicer
#
# Description: 
#   Main module for file processing
#   
#
########################################################################

module Icersplicer

  module VERSION #:nodoc:

    MAJOR = 0
    MINOR = 2
    TINY = 8
    CODENAME = "Icestorm !"

    STRING = [MAJOR, MINOR, TINY].join('.')

  end
  
  @@nfile = 0
  @@exp = nil
  @@keywordsfile = "keywords.ice"
  
  def load_keywords(file)
    keys = Array.new
    unless Dir.exists?("#{Dir.home}/.icersplicer")
      Dir.mkdir("#{Dir.home}/.icersplicer")
    end
    if File.exists?("#{Dir.home}/.icersplicer/#{file}")
      File.open("#{Dir.home}/.icersplicer/#{file}") {|n|
        n.each_line {|l|
          keys << l.strip
        }
      }
      return keys
    else
      return false
    end
  end
  
  def text_highlighter(text)
    keys = load_keywords("#{@@keywordsfile}")
    if keys == false
    keys = ["Ln:", "SELECT", "CREATE TABLE", "UPDATE", "DELETE", "INSERT", "FROM", "OFFSET", "GROUP BY", "HAVING", "ORDER BY",
            "ALTER USER", "ALTER TABLE", "COPY", "INTO", "VALUES", "DELIMITERS", "STDIN", "CREATE USER", "WITH", "USING",
            "CREATE INDEX", "CONSTRAINT", "ALTER INDEX", "INTEGER", "CHAR", "CLOB", "VARCHAR", "STRING", "DEFAULT", "NULL", "NOT",
            "RECORDS", "KEY", "PRIMARY", "FOREIGN", "BIGINT", "MERGE", "REMOTE", "DROP TABLE", "SET SCHEMA", "CREATE SCHEMA",
            "ALTER SCHEMA", "ADD", "TABLE", "CREATE SEQUENCE", "ALTER SEQUENCE"]
    end
    cpicker = [2,3,4,1,7,5,6] # Just a selection of colours
    keys.each {|n|
      text.gsub!("#{n}", "\e[4;3#{cpicker[rand(cpicker.size)]}m#{n}\e[0m\ \e[0;32m".strip)
    }
    return text
  end

  def countlines(inputfile)
    lines = 0
    unless inputfile == nil
      if File.exists?(inputfile)
        File.open(inputfile) {|n|
          n.each_line {
            lines += 1
          }
        }
        puts "Filename: #{inputfile} Total Line Count: #{lines}"
      end
    end
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

  def openfile(outputfile)
    puts "Openfile: #{outputfile}"
    @@exp = File.open("#{outputfile}", 'w')
  end

  def writefile(data)
    @@exp.write(data)
  end

  def closefile
    @@exp.close
    puts "Closing file: #{outputfile}"
  end

  def processdata(data, outputfile, quietmode)
    openfile(outputfile) if @@nfile == 0
    writefile(data)
    @@nfile += 1
  end

  def stats(inputfile, outputfile)
    print "Inputfile lines: "
    countlines(inputfile)
    #print "Outputfile lines: "
    #countlines(outputfile)
  end

end
