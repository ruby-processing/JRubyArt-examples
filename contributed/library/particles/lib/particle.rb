# encoding: utf-8
# frozen_string_literal: true
# Particles + Forces
# Daniel Shiffman <http://www.shiffman.net>

require 'forwardable'

# Particle class incorporates forces code and ring_buffer code
# using forwardable
class Particle
  include Enumerable, Processing::Proxy
  extend Forwardable
  def_delegators(:@points, :each, :shift, :size)
  attr_accessor :loc, :vel, :acc, :points, :radius
  MAX_SPEED = 8
  MAX_SIZE = 20_000 # of ring_buffer, is about right size

  def initialize(acceleration:,
                 velocity:,
                 location:,
                 radius: 10
                )
    @acc = acceleration
    @vel = velocity
    @loc = location
    @radius = radius
    @timer = 100.0
    @points = []
  end

  def <<(el)
    shift unless size < MAX_SIZE
    points << el
  end

  def run
    update
    render
  end

  # Method to update @location
  def update
    @vel += acc
    vel.set_mag(MAX_SPEED) { vel.mag > MAX_SPEED }
    @loc += @vel
    @acc *= 0.0
    self << loc.to_a # store vector as array to save space
  end

  def apply_force(force)
    # mass = 1 # We aren't bothering with mass here
    # force / mass
    @acc += force
  end

  # Method to display
  def render
    ellipse_mode(CENTER)
    stroke(255)
    fill(100)
    ellipse(loc.x, loc.y, radius, radius)
    each { |pt| point(pt[X], pt[Y], 0) }
  end
end
