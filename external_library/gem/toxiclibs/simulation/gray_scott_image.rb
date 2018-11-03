require 'toxiclibs'

# <p>GrayScottImage uses the seedImage() method to use a bitmap as simulation seed.
# In this demo the image is re-applied every frame and the user can adjust the
# F coefficient of the reaction diffusion to produce different patterns emerging
# from the boundary of the bitmapped seed. Unlike some other GS demos provided,
# this one also uses a wrapped simulation space, creating tiled patterns.</p>
#
# <p><strong>usage:</strong></p>
# <ul>
# <li>click + drag mouse to locally disturb the simulation</li>
# <li>press 1-9 to adjust the F parameter of the simulation</li>
# <li>press any other key to reset</li>
# </ul>
#

#
# Copyright (c) 2010 Karsten Schmidt
#
# This demo & library is free software you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation either
# version 2.1 of the License, or (at your option) any later version.
#
# http:#creativecommons.org/licenses/LGPL/2.1/
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

attr_reader :gs, :tone_map, :img

def setup
  sketch_title 'Gray Scott Image'
  @gs = Simulation::GrayScott.new width, height, true
  @img = load_image(data_path('ti_yong.png'))
  # create a duo-tone gradient map with 256 steps
  # NB: use '::' in place of '.' here for these java constants
  @tone_map = Toxi::ToneMap.new(0,  0.33, Toxi::NamedColor::CRIMSON, Toxi::NamedColor::WHITE, 256)
end

def draw
  @gs.seed_image(img.pixels, img.width, img.height)
  @gs.set_rect(mouse_x, mouse_y, 20, 20) if mouse_pressed?
  load_pixels
  10.times { @gs.update(1) }
  # read out the V result array
  # and use tone map to render colours
  @gs.v.each_with_index do |v, i|
    pixels[i] = tone_map.getARGBToneFor(v)  # NB: don't camel case convert here
  end
  update_pixels
end

def key_pressed
  control_key = %w[1 2 3 4 5 6 7 8 9].freeze
  case key
  when *control_key
    @gs.setF(0.02 + (key.to_i) * 0.001)
  when 's'
    save_frame(data_path('toxi.png'))
  else
    @gs.reset()
  end
end


def settings
  size(256, 256, P2D)
end
