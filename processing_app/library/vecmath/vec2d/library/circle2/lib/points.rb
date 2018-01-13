# frozen_string_literal: true
require 'forwardable'
MAX_POINT = 3
# A collection of a maximum of 3 points in a Math World
# includes a collinearity test, and a map to simple Vec2D array
class TPoints
  extend Forwardable
  def_delegators(:@points, :each, :map, :size, :shift, :clear, :[])
  include Enumerable

  attr_reader :points

  def initialize
    @points = []
  end

  def <<(pt)
    points << pt
    shift if size > MAX_POINT
  end

  def collinear?
    return false unless full?
    (array[0] - array[1]).cross(array[1] - array[2]).zero?
  end

  def array
    points.map(&:pos)
  end

  def full?
    points.length == MAX_POINT
  end
end
