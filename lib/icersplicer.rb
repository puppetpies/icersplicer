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

module Icersplicer

  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 8
    TINY = 0
    CODENAME = "Ice Age !"
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  @@nfile = 0
  @@exp = nil
  @@keywordsfile = "keywords.ice"
  @@debug = false

  COLOURS = {"black" => 0,
             "red" => 1, 
             "green" => 2, 
             "yellow" => 3, 
             "blue" => 4,
             "purple" => 5,
             "cyan" => 6,
             "white" => 7}

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
    unless Dir.exists?("#{Dir.home}/.icersplicer")
      Dir.mkdir("#{Dir.home}/.icersplicer")
    end
    if File.exists?("#{Dir.home}/.icersplicer/#{file}")
      File.open("#{Dir.home}/.icersplicer/#{file}") {|n|
        n.each_line {|l|
          keys.update({linenum => "#{l.strip}"}) unless l.strip == ""
          puts "L: #{l.strip}" if @@debug == true
          linenum += 1
        }
      }
      return keys
    else
      return false
    end
  end

  def text_processor(data)
    unless instance_variable_defined?("@nohighlighter")
      data = text_highlighter(data)
      return data
    else
      return data
    end
  end

  def text_highlighter(text)
    @keys ||= load_keywords("#{@@keywordsfile}")
    unless @keys.class == Hash
      @keys = {0 => "Ln:", 
               1 => "SELECT", 
               2 => "CREATE TABLE", 
               3 => "UPDATE", 
               4 => "DELETE", 
               5 => "INSERT"}
    end
    cpicker = [2,3,4,1,7,5,6] # Just a selection of colours
    @keys.each {|n|
      if n[1].split("##")[1] == nil
        text.gsub!("#{n[1]}", "\e[4;3#{cpicker[rand(cpicker.size)]}m#{n[1]}\e[0m\ \e[0;32m")
      else
        name = n[1].split("##")[1].split("=")[1]; puts "Name: #{name}" if @@debug == true
        cnum = COLOURS[name].to_i; puts "Colour Number: #{cnum}" if @@debug == true
        nval = n[1].split("##")[0]; puts "Value: #{nval}" if @@debug == true
        text.gsub!("#{nval}", "\e[4;3#{cnum}m#{nval}\e[0m\ \e[0;32m")
      end
      text.gsub!(" \e[0;32m", "\e[0;32m")
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
        puts "Min: #{min} Max: #{max}" if @debug == true
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
    puts "\e[1;33mLn: #{linenum}:\e[0m\ #{text}" unless quiet == true
  end

  def openfile(outputfile)
    begin
      puts "Openfile: #{outputfile}"
     @@exp = File.open("#{outputfile}", 'w')
    rescue Errno::EACCES
      puts "Can't create file please check file / directory permissions"
    end
  end

  def writefile(data)
    @@exp.write(data)
  end

  def closefile
    begin
      @@exp.close
      puts "Closing file"
    rescue NoMethodError
    end
  end

  def processdata(data, outputfile, quietmode)
    openfile(outputfile) if @@nfile == 0
    writefile(data)
    @@nfile += 1
  end

  def stats(inputfile, outputfile)
    print "Inputfile lines: "
    countlines(inputfile)
  end

end
