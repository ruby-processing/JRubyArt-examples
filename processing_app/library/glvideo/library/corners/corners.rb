# frozen_string_literal: true
require 'forwardable'
# placeholder for vector coordinates
Vect = Struct.new(:x, :y)

# A class to contain frame corners, uses forwardable
class Corners
  include Enumerable
  extend Forwardable
  def_delegators :@corners, :each_with_index, :[], :[]=, :<<
  attr_reader :idx

  def initialize(width, height, ws, wh)
    @corners = [
      Vect.new(width / 2 - ws, height / 2 - wh),
      Vect.new(width / 2 + ws, height / 2 - wh),
      Vect.new(width / 2 + ws, height / 2 + wh),
      Vect.new(width / 2 - ws, height / 2 + wh)
    ]
    @idx = -1
  end

  def set_corner(mx, my)
    self[idx] = Vect.new(mx, my)
  end

  def selected?
    idx != -1
  end

  def set_index(sel)
    @idx = sel
  end
end
