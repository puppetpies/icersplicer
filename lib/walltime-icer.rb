########################################################################
#
# Author: Brian Hood
#
# Description: Walltime
#
# A stopwatch project for all kinds of things
#
########################################################################

module NumTools

  # Implement more if you wish only interested in round myself right now.
  def random_between(min, max); min+rand(max); end

  def self.define_component(name)
    name_func = name.to_s.gsub("_to", "").to_sym
    define_method(name) do |val, x|  
      (val * 10**x).send("#{name_func}").to_f / 10**x
    end
  end

  define_component :round_to

end

class Stopwatch

  include NumTools

  attr_reader :t1, :t2, :roundvals

  private

  def initialize
    @roundvals = []
  end
  
  def intervalh
    round = round_to(@t2 - @t1, 2)
    t1h, t2h, @calc = Time.at(@t1), Time.at(@t2), round
    record(round)
  end

  protected

  def timestamp; Time.now.to_f; end

  public

  def record(round)
    @roundvals << round
  end
  
  def print_stats
    round = round_to(@t2 - @t1, 2)
    puts "Start: #{Time.at(@t1)} Finish: #{Time.at(@t2)} Total time: #{round}"
  end
  
  def watch(method)
    if method == "start"
      @t1 = timestamp
    elsif method == "stop"
      @t2 = timestamp
      intervalh
    end
  end
  
end
