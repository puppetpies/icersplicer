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
require 'file-tail'
require 'rainbow'

module OutputFile

    @@fileopen = 0
    
    def open(outputfile)
      begin
        puts "Openfile: #{outputfile}" if @debug >= 1
        @export = File.open("#{outputfile}", 'w')
      rescue Errno::EACCES
        raise IOError, "Can't create file please check file / directory permissions"
      end
    end

    def write(data)
      @export.write(data)
    end

    def close
      begin
        @export.close
        puts "Closing file"
      rescue NoMethodError
      end
    end

    def processdata(data, outputfile, quietmode)
      open(outputfile) if @@fileopen == 0
      write(data)
      @@fileopen += 1
    end
    
end

module Icersplicer

  class FileProcessor
  
    attr_writer :nohighlighter, :skip_lines, :keywordsfile, :debug, :nolinenumbers
    
    include OutputFile
    
    COLOURS = {0 => "black",
               1 => "red", 
               2 => "green", 
               3 => "yellow", 
               4 => "blue",
               5 => "purple",
               6 => "cyan",
               7 => "white"}

    def initialize
      @keywordsfile = "keywords.ice"
      @debug = 0
      @nolinenumbers = false
    end
    
    def reset_screen
      puts "\e[0m\ "
    end
    
    def filterlinestats(filterlines)
      puts "\nLines Displayed by Filter: #{filterlines}"
    end

    def followtail(filename, number)
      File::Tail::Logfile.open(filename) do |log|
        log.interval = 3
        log.backward(10)
        log.backward(number).tail { |line| puts line }
      end
      exit
    end

    def load_keywords(file)
      keys = Hash.new
      linenum = 0
      unless Dir.exist?("#{Dir.home}/.icersplicer")
        Dir.mkdir("#{Dir.home}/.icersplicer")
      end
      if File.exists?("#{Dir.home}/.icersplicer/#{file}")
        File.open("#{Dir.home}/.icersplicer/#{file}") {|n|
          n.each_line {|l|
            keys.update({linenum => "#{l.strip}"}) unless l.strip == ""
            puts "L: #{l.strip}" if @debug >= 1
            linenum += 1
          }
        }
        return keys
      else
        return false
      end
    end

    def text_processor(data)
      unless @nohighlighter == "OFF"
        data = text_highlighter(data)
        return data
      else
        return data
      end
    end

    def text_highlighter(text)
      keys ||= load_keywords("#{@keywordsfile}")
      unless keys.class == Hash
        keys = {0 => "Ln:", 
                1 => "SELECT", 
                2 => "CREATE TABLE", 
                3 => "UPDATE", 
                4 => "DELETE", 
                5 => "INSERT"}
      end
      cpicker = [2,3,4,1,7,5,6] # Just a selection of colours
      keys.each {|n|
        if n[1].split("##")[1] == nil
          name = COLOURS[rand(COLOURS.size - 1)]
          text.gsub!("#{n[1]}", Rainbow.new.wrap("#{n[1]}").send(name.to_sym))
        else
          nval = n[1].split("##")[0]; puts "Value: #{nval}" if @debug >= 3
          name = n[1].split("##")[1].split("=")[1]; puts "Value: #{name}" if @debug >= 3
          text.gsub!("#{nval}", Rainbow.new.wrap("#{nval}").send(name.to_sym))
        end
      }
      return text
    end

    def countlines(inputfile)
      lines = 0
      unless inputfile == nil
        if File.exist?(inputfile)
          File.open(inputfile) {|n|
            n.each_line {
              lines += 1
            }
          }
          puts "Filename: #{inputfile} Total Line Count: #{lines}"
        end
      end
      return lines
    end
    
    def skip_processor(filter)
      skip_lines = Hash.new
      skipcounter = 0
      filter.to_s.split(",").each {|n| 
        skip_lines.update({skipcounter => n.to_i}) 
        # Allow line ranges 
        min = n.split("-")[0].to_i
        max = n.split("-")[1].to_i
        puts "Min: #{min} Max: #{max}" if @debug >= 2
        unless n.split("-")[1] == nil
          if min > max
            raise RangeError, "Range Error: Minimun value can't be more than Maxiumun Range value"              
          end
          min.upto(max) {|s|
            skip_lines.update({skipcounter => s}) unless skip_lines[skip_lines.size - 1] == s
            skipcounter += 1
          }
        end
        skipcounter += 1
      }
      return skip_lines
    end
    
    def skip(line)
      begin
        if instance_variable_defined?("@skip_lines")
          line_element = @skip_lines.key(line)
          if line_element != nil
            skiper = @skip_lines[line_element]
          end
        end
      rescue NoMethodError
        return nil
      end
      return skiper
    end

    def print_to_screen(linenum, text, quiet)
      unless @nolinenumbers == true or quiet == true
        print Rainbow.new.wrap("Ln: #{linenum}:").yellow
      end
      print "#{text}" unless quiet == true
    end

    def stats(inputfile, outputfile)
      puts "Skip Lines #{@skip_lines}" if @debug >= 1
      print "Inputfile lines: "
      countlines(inputfile)
    end

  end
  
end
