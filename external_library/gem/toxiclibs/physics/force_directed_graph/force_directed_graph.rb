#
# <p>Force directed graph,
# heavily based on: <a href="http://code.google.com/p/fidgen/">fid.gen</a><br/>
# <a href="http://www.shiffman.net/teaching/nature/toxiclibs/">The Nature of Code</a><br/>
# Spring 2010</p>
#
# Copyright (c) 2010 Daniel Shiffman
#
# This demo & library is free software you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation either
# version 2.1 of the License, or (at your option) any later version.
#
# http://creativecommons.org/licenses/LGPL/2.1/
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
require 'forwardable'
require 'toxiclibs'
require_relative 'cluster'
require_relative 'node'

attr_reader :physics, :clusters, :show_physics, :show_particles, :f

def setup
  sketch_title 'Force Directed Graph'
  @f = create_font('Georgia', 12, true)
  @show_physics = true
  @show_particles = true
  # Initialize the physics
  @physics = Physics::VerletPhysics2D.new
  physics.setWorldBounds(Toxi::Rect.new(10, 10, width - 20, height - 20))
  # Spawn a new random graph
  new_graph
end

# Spawn a new random graph
def new_graph
  # Clear physics
  physics.clear
  center = TVec2D.new(width / 2, height / 2)
  @clusters = (0..8).map { Cluster.new(rand(3..8), rand(20..100), center) }
  #	All clusters connect to all clusters
  clusters.each_with_index do |ci, i|
    clusters[i + 1..clusters.size - 1].each do |cj|
      ci.connect(cj)
    end
  end
end

def draw
  # Update the physics world
  physics.update
  background(255)
  # Display all points
  clusters.each(&:display) if show_particles
  # If we want to see the physics
  if show_physics
    clusters.each_with_index do |ci, i|
      ci.internal_connections
      # Cluster connections to other clusters
      clusters[1 + i..clusters.size - 1].each do |cj|
        ci.show_connections(cj)
      end
    end
  end
  # Instructions
  fill(0)
  text_font(f)
  text("'p' to display or hide particles\n'c' to display or hide connections\n'n' for new graph", 10, 20)
end

# Key press commands
def key_pressed
  case key
  when 'c'
    @show_physics = !show_physics
    @show_particles = true unless show_physics
  when 'p'
    @show_particles = !show_particles
    @show_physics = true unless show_particles
  when  'n'
    new_graph
  end
end

def settings
  size(640, 360)
end
