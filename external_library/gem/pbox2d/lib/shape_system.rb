require 'forwardable'

module Runnable
  def run
    reject! { |item| item.done }
    each { |item| item.display }
  end
end

class ShapeSystem
  include Enumerable, Runnable
  extend Forwardable
  def_delegators(:@polygons, :each, :reject!, :<<)

  attr_reader :bd
  
  def initialize(bd)
    @bd = bd
    @polygons = []          # Initialize the Array
  end
  
  def add_polygon(x, y)
    self << CustomShape.new(bd, x, y)
  end
end


