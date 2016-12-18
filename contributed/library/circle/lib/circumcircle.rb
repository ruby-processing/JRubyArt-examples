# frozen_string_literal: true
require 'matrix'

# Circumcircle from 3 points
class Circumcircle
  attr_reader :center, :radius, :points
  def initialize(points)
    @points = points
  end

  def calculate
    @center = Vec2D.new(-(bx / am), -(by / am))
    @radius = center.dist(points[2]) # points[2] = c
  end

  private

  # Matrix math see matrix_math.md and in detail
  # http://mathworld.wolfram.com/Circumcircle.html

  def am
    2 * Matrix[
      *points.map { |pt| [pt.x, pt.y, 1] }
    ].determinant
  end

  def bx
    -Matrix[
      *points.map { |pt| [pt.x * pt.x + pt.y * pt.y, pt.y, 1] }
    ].determinant
  end

  def by
    Matrix[
      *points.map { |pt| [pt.x * pt.x + pt.y * pt.y, pt.x, 1] }
    ].determinant
  end
end
