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

def text_highlighter(text)
  keys = ["Ln:", "SELECT", "CREATE TABLE", "UPDATE", "DELETE", "INSERT", "FROM", "OFFSET", "GROUP BY", "HAVING", "ORDER BY",
          "ALTER USER", "ALTER TABLE", "COPY", "INTO", "VALUES", "DELIMITERS", "STDIN", "CREATE USER", "WITH", "USING",
          "CREATE INDEX", "CONSTRAINT", "ALTER INDEX", "INTEGER", "CHAR", "CLOB", "VARCHAR", "STRING", "DEFAULT", "NULL", "NOT",
          "RECORDS", "KEY", "PRIMARY", "FOREIGN", "BIGINT", "MERGE", "REMOTE", "DROP TABLE", "SET SCHEMA", "CREATE SCHEMA",
          "ALTER SCHEMA", "ADD", "TABLE"]
  cpicker = [2,3,4,1,7,5,6] # Just a selection of colours
  keys.each {|n|
    text.gsub!("#{n}", "\e[4;3#{cpicker[rand(cpicker.size)]}m#{n}\e[0m\ \e[0;32m".strip)
  }
  return text
end

lineoffset = 700000
linelimit = 20000
increment_offset = 0
increment_limit = 0
linecounter = 0
@skiplines = [148]
quiet = true

inputfile = "/data2/threatmonitor.sql"
outputfile = "/data2/tmpdata.sql"

def skip(line)
  line_element = @skiplines.index(line)
  if line_element != nil
    skiper = @skiplines[line_element]
    @skiplines.delete_at(line_element)
  end
  return skiper
end

def print_to_screen(linenum, text, quiet)
  puts "\e[1;33mLn: #{linenum}:\e[0m\ #{text}" unless quiet == true
end

File.open(outputfile, 'w') {|w|
  File.open(inputfile) {|n|
    n.each_line {|l|
      unless lineoffset > increment_offset
        unless linelimit == 0
          unless increment_limit > linelimit
            print_to_screen(linecounter, text_highlighter(l), quiet) unless skip(linecounter) == linecounter
            w.write(l)
          end
        else
          print_to_screen(linecounter, text_highlighter(l), quiet) unless skip(linecounter) == linecounter
          w.write(l)
        end
        increment_limit += 1
      end
      increment_offset += 1
      linecounter += 1
    }
  }
}

