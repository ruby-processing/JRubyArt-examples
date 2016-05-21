require 'toxiclibs'

#
# <p>GrayScottToneMap shows how to use the ColorGradient & ToneMap classes of the
# colorutils package to create a tone map for rendering the results of
# the Gray-Scott reaction-diffusion.</p>
#
# <p><strong>Usage:</strong><ul>
# <li>click + drag mouse to draw dots used as simulation seed</li>
# <li>press any key to reset</li>
# </ul></p>
#
# Copyright (c) 2010 Karsten Schmidt, JRubyArt Version (c) 2015 Martin Prout

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

NUM_ITERATIONS = 10  
attr_reader :gs, :tone_map

def setup 
  sketch_title 'Gray Scott Tone Map'
  @gs = Simulation::GrayScott.new width, height, false
  @gs.set_coefficients 0.021, 0.076, 0.12, 0.06
  # create a color gradient for 256 values
  grad = Toxi::ColorGradient.new
  # NamedColors are preset colors, but any TColor can be added
  # see javadocs for list of names:
  # http://toxiclibs.org/docs/colorutils/toxi/color/NamedColor::html
  # NB: use '::' in place of '.' here for these java constants
  grad.add_color_at(0, Toxi::NamedColor::BLACK)
  grad.add_color_at(128, Toxi::NamedColor::RED)
  grad.add_color_at(192, Toxi::NamedColor::YELLOW)
  grad.add_color_at(255, Toxi::NamedColor::WHITE)
  # this gradient is used to map simulation values to colors
  # the first 2 parameters define the min/max values of the
  # input range (Gray-Scott produces values in the interval of 0.0 - 0.5)
  # setting the max = 0.33 increases the contrast
  @tone_map = Toxi::ToneMap.new 0, 0.33, grad
end

def draw     
  @gs.set_rect(mouse_x, mouse_y, 20, 20) if mouse_pressed?
  load_pixels
  # update the simulation a few time steps
  NUM_ITERATIONS.times { @gs.update(1) }
  # read out the V result array
  # and use tone map to render colours
  gs.v.each_with_index do |v, i|
    pixels[i] = tone_map.getARGBToneFor(v)  # NB: don't camel case convert here
  end
  update_pixels
end

def key_pressed
  @gs.reset
end

def settings
  size(256,256, P2D)
end

