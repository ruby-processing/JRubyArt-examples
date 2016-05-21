# <p>A soft pendulum (series of connected springs)<br/>
# <a href="http://www.shiffman.net/teaching/nature/toxiclibs/">The Nature of Code</a><br/>
# Spring 2010</p>
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

require 'toxiclibs'
require_relative 'particle'
require_relative 'chain'

attr_reader :physics, :chain

def settings
  size(640, 360)
end

def setup
  sketch_title 'Soft String Pendulum'
  # Initialize the physics world
  @physics = Physics::VerletPhysics2D.new
  physics.addBehavior(Physics::GravityBehavior2D.new(TVec2D.new(0, 0.1)))
  physics.setWorldBounds(Toxi::Rect.new(0, 0, width, height))
  # Initialize the chain
  @chain = Chain.new(physics, 180, 20, 16, 0.2)
end

def draw
  background(255)
  # Update physics
  physics.update
  # Update chain's tail according to mouse location
  chain.update_tail(mouse_x, mouse_y)
  # Display chain
  chain.display
end

def mouse_pressed
  # Check to see if we're grabbing the chain
  chain.contains(mouse_x, mouse_y)
end

def mouse_released
  # Release the chain
  chain.release
end
