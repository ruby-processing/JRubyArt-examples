# Circumcircle from 3 points
require 'matrix'

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
      [points[0].x, points[0].y, 1],
      [points[1].x, points[1].y, 1],
      [points[2].x, points[2].y, 1]
    ].determinant
  end

  def bx
    -Matrix[
      [points[0].x * points[0].x + points[0].y * points[0].y, points[0].y, 1],
      [points[1].x * points[1].x + points[1].y * points[1].y, points[1].y, 1],
      [points[2].x * points[2].x + points[2].y * points[2].y, points[2].y, 1]
    ].determinant
  end

  def by
    Matrix[
      [points[0].x * points[0].x + points[0].y * points[0].y, points[0].x, 1],
      [points[1].x * points[1].x + points[1].y * points[1].y, points[1].x, 1],
      [points[2].x * points[2].x + points[2].y * points[2].y, points[2].x, 1]
    ].determinant
  end
end
