# encoding: utf-8
# frozen_string_literal: true
# Attraction
# Daniel Shiffman <http://www.shiffman.net>
# A class for a @draggable attractive body in our world
class Attractor
  include Processing::Proxy
  attr_accessor :loc, :gravity, :mass

  def initialize(location:, mass:, gravity:)
    @loc = location
    @mass = mass
    @gravity = gravity
    # @drag = Vec3D.new(0.0, 0.0)
  end

  def go
    render
    # drag
  end

  def calc_grav_force(p)
    dir = loc - p.loc # Calculate direction of force
    d = dir.mag # Distance between objects
    # Limit the distance to eliminate "extreme" result of very close or very far objects
    d = constrain(d, 5.0, 50.0)
    # Normalize vector (distance doesn't matter here, we just want this vector for direction)
    dir.normalize!
    force = (gravity * mass * 1 / (d * d)) # Calculate gravitional force magnitude
    dir * force # @Get force vector --> magnitude * direction
  end

  # Method to display
  def render
    ellipse_mode(CENTER)
    stroke(0)
    fill(175, 200)
    ellipse(loc.x, loc.y, mass * 2, mass * 2)
  end
end
