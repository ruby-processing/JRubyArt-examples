# The Nature of Code
# Daniel Shiffman
# http://natureofcode.com
#
# This example is adapted from Karsten Schmidt's SoftBodySquare example
#
# <p>Softbody square demo is showing how to create a 2D square mesh out of
# verlet particles and make it stable enough to adef total structural
# deformation by including an inner skeleton.</p>
#
# <p>Usage: move mouse to drag/deform the square</p>
#
#
# Copyright (c) 2008-2009 Karsten Schmidt
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
require 'toxiclibs'
require 'forwardable'
require_relative 'blanket'
require_relative 'connection'
require_relative 'particle'

attr_reader :b, :physics

def settings
  size 640, 360
end

def setup
  sketch_title 'Soft Body Square'
  @physics = Physics::VerletPhysics2D.new
  physics.add_behavior(Physics::GravityBehavior2D.new(TVec2D.new(0, 0.1)))
  @b = Blanket.new physics
end

def draw
  background(255)
  physics.update
  b.display
end
