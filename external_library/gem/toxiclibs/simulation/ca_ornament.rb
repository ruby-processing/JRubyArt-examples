# <p>Much like the GameOfLife example, this de_mo shows the basic usage
# pattern for the 2D cellular automata imple_mentation, this time however
# utilizing cell aging and using a tone map to render its current state.
# The CA simulation can be configured with birth and survival rules to
# create all the complete set of rules with a 3x3 cell evaluation kernel.</p>
#
# <p><strong>Usage:</strong><ul>
# <li>click + drag mouse to disturb the CA matrix</li>
# <li>press 'r' to restart simulation</li>
# </ul></p>
#
# Copyright (c) 2011 Karsten Schmidt
#
# This de_mo & library is free software you can redistribute it and/or
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
include_package 'toxi.sim.automata'
include_package 'toxi.math'

attr_reader :ca, :tone_map

def settings
  size(680, 382, P2D)
end

def setup
  sketch_title 'CA Ornament'
  # the birth rules specify options for when a cell becomes active
  # the numbers refer to the amount of ACTIVE neighbour cells allowed,
  # their order is irrelevant
  birth_rules = [1, 5, 7].to_java Java::byte
  # survival rules specify the possible numbers of allowed or required
  # ACTIVE neighbour cells in order for a cell to stay alive
  survival_rules = [0, 3, 5, 6, 7, 8].to_java Java::byte
  # setup cellular automata matrix
  @ca = CAMatrix.new(width, height)
  # unlike traditional CA's only supporting binary cell states
  # this implementation supports a flexible number of states (cell age)
  # in this demo cell states reach from 0 - 255
  rule = CARule2D.new(birth_rules, survival_rules, 256, false)
  # we also want cells to automatically die when they've reached their
  # maximum age
  rule.set_auto_expire(true)
  # finally assign the rules to the CAMatrix
  ca.set_rule(rule)
  # create initial seed pattern
  ca.draw_box_at(0, height / 2, 5, 1)
  # create a gradient for rendering/shading the CA
  grad = Toxi::ColorGradient.new
  # NamedColors are preset colors, but any TColor can be added
  # see javadocs for list of names:
  # http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor.html
  grad.add_color_at(0, Toxi::NamedColor::BLACK)
  grad.add_color_at(64, Toxi::NamedColor::CYAN)
  grad.add_color_at(128, Toxi::NamedColor::YELLOW)
  grad.add_color_at(192, Toxi::NamedColor::WHITE)
  grad.add_color_at(255, Toxi::NamedColor::BLACK)
  # the tone map will map cell states/ages to a gradient color
  @tone_map = Toxi::ToneMap.new(0, rule.get_state_count - 1, grad)
end

def draw
  load_pixels
  ca.draw_box_at(mouse_x, mouse_y, 5, 1) if mouse_pressed?
  ca.update
  tone_map.get_tone_mapped_array(ca.get_matrix, pixels)
  update_pixels
end

def key_pressed
  return unless key == 'r'
  ca.reset
end
