require 'forwardable'
require_relative './rotator'

class Branch
  include Enumerable
  extend Forwardable
  def_delegators(:@children, :<<, :each, :length)
  # variance angle for growth direction per time step
  THETA = Math::PI / 6
  # max segments per branch
  MAX_LEN = 100
  # max recursion limit
  MAX_GEN = 3
  # branch chance per time step
  BRANCH_CHANCE = 0.05
  # branch angle variance
  BRANCH_THETA = Math::PI / 4
  attr_reader :position, :dir, :path, :children, :xbound, :speed, :ybound, :app, :zbound

  def initialize(app, pos, dir, speed)
    @app = app
    @position = pos
    @dir = dir
    @speed = speed
    @path = []
    @children = []
    @xbound = Boundary.new(-600, 600)
    @ybound = Boundary.new(-150, 150)
    @zbound = Boundary.new(-150, 150)
    path << pos
  end

  def run
    grow
    display
  end

  private

  def grow
    check_bounds(position + (dir * speed))
    @position += (dir * speed)
    (0..2).each do |axis|
      Rotate.axis!(axis, dir, rand(-0.5..0.5) * THETA)
    end
    path << position
    if (length < MAX_GEN) && (rand < BRANCH_CHANCE)
      branch_dir = dir.copy
      (0..2).each do |axis|
        Rotate.axis!(axis, branch_dir, rand(-0.5..0.5) * BRANCH_THETA)
      end
      self << Branch.new(app, position.copy, branch_dir, speed * 0.99)
    end
    each(&:grow)
  end

  def display
    app.begin_shape
    app.stroke 255
    app.stroke_weight 0.5
    app.no_fill
    path.each { |vec| vec.to_vertex(app.renderer) }
    app.end_shape
    each(&:display)
  end

  def check_bounds(pos)
    dir.x *= -1 if xbound.exclude? pos.x
    dir.y *= -1 if ybound.exclude? pos.y
    dir.z *= -1 if zbound.exclude? pos.z
  end
end

# we are looking for excluded values
Boundary = Struct.new(:lower, :upper) do
  def exclude?(val)
    true unless (lower...upper).cover? val
  end
end
