# run system with a single command
module Runnable
  def run
    reject!(&:done?)
    each(&:display)
  end
end

# A custom enumerable class, it is so easy in ruby
class ParticleSystem
  include Enumerable, Runnable
  extend Forwardable
  def_delegators(:@pairs, :each, :reject!, :<<)
  
  def initialize
    @pairs = []
  end
  
  def add_pair(x, y)
    self << Pair.new(x, y)
  end
end
