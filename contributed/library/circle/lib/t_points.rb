# frozen_string_literal: true
require 'forwardable'
MAX_POINT = 3
# A collection of a maximum of 3 points in the processing world
# includes a collinearity test using Vec2D
class TrianglePoints
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
    full? ? (positions[0] - positions[1]).cross(positions[1] - positions[2]).zero? : false
  end

  # returns positions as an array of Vec2D
  def positions
    points.map(&:pos)
  end

  def full?
    points.length == MAX_POINT
  end
end
