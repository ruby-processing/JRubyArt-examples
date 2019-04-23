load_libraries :handy, :gicentreUtils
java_import 'org.gicentre.handy.HandyPresets'
java_import 'org.gicentre.handy.HandyRenderer'
java_import 'org.gicentre.utils.move.ZoomPan'
#*****************************************************************************************
# Simple sketch to show handy shape drawing in four different present styles. H key toggles
#  sketchy rendering on or off. Left and right arrows change the hachure angle. Image zoomed
#  and panned with mouse drag.
#  @author Jo Wood, giCentre, City University London.
#  @version JRubyArt translated by Martin Prout
#
# *****************************************************************************************

# self file is part of Handy sketchy drawing library. Handy is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# Handy is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along with self
# source code (see COPYING.LESSER included with self source code). If not, see
# http://www.gnu.org/licenses/.
#

# ----------------------------- Object variables ------------------------------

attr_reader :pencil, :marker, :water, :cPencil, :border, :zoomer, :angle
attr_reader :isHandy, :sketchyFont, :normalFont

# ---------------------------- Processing methods -----------------------------
def settings
  size(1200, 800)
  # Should work with all Processing 3 renderers.
  # size(1200, 800, P2D)
  # size(1200, 800, P3D)
  # size(1200, 800, P2D)
  pixelDensity(displayDensity) # Use platform's maximum display density.
end

def setup
  sketch_title 'Preset Styles Demo'
  @zoomer = ZoomPan.new(self)
  @angle = -42
  @isHandy = true
  @pencil  = HandyPresets.create_pencil(self)
  @water   = HandyPresets.create_water_and_ink(self)
  @marker  = HandyPresets.create_marker(self)
  @cPencil = HandyPresets.create_coloured_pencil(self)
  @border = HandyRenderer.new(self)
  pencil.set_hachure_angle(angle)
  water.set_hachure_angle(angle)
  marker.set_hachure_angle(angle)
  cPencil.set_hachure_angle(angle)
  @sketchyFont = load_font(data_path('HumorSans-32.vlw'))
  @normalFont = create_font('sans-serif', 32)
end

def draw
  background(255)
  zoomer.transform
  pencil.set_seed(1234)
  water.set_seed(1234)
  marker.set_seed(1234)
  cPencil.set_seed(1234)
  stroke(0)
  stroke_weight(1)
  textAlign(RIGHT,BOTTOM)
  if isHandy
     text_font(sketchyFont)
  else
    text_font(normalFont)
  end
  srand(10)
  no_fill
  border.rect(10, 10, width / 2 - 20, height / 2 - 20)
  draw_shapes(pencil, 0, 0, width / 2, height / 2)
  fill(60)
  text('Pencil', width / 2 - 20, height / 2-15)
  no_fill
  border.rect(width / 2 + 10, 10,width / 2 - 20, height / 2 - 20)
  draw_shapes(water, width / 2, 0, width / 2, height / 2)
  fill(60)
  text('Ink and watercolour', width - 20,height / 2-15)
  no_fill
  border.rect(10, height / 2 + 10, width / 2 - 20, height / 2 - 20)
  draw_shapes(marker, 0, height / 2, width / 2, height / 2)
  fill(60)
  text('Marker pen', width / 2 - 20, height - 15)
  no_fill
  border.rect(width / 2 + 10, height / 2 + 10, width / 2 - 20, height / 2 - 20)
  draw_shapes(cPencil,width/2,height / 2,width/2,height / 2)
  fill(60)
  text('Coloured pencil', width - 20,height - 15)
  no_loop
end

def key_pressed
  case key
  when 'h', 'H'
    @isHandy = !isHandy
    pencil.setIsHandy(isHandy)
    water.setIsHandy(isHandy)
    marker.setIsHandy(isHandy)
    cPencil.setIsHandy(isHandy)
    loop
  when 'r', 'R'
    zoomer.reset
    loop
  else
    return unless key == CODED
  end
  case key_code
  when LEFT
    @angle -= 1
    pencil.set_hachure_angle(angle)
    water.set_hachure_angle(angle)
    marker.set_hachure_angle(angle)
    cPencil.set_hachure_angle(angle)
    loop
  when RIGHT
    @angle += 1
    pencil.set_hachure_angle(angle)
    water.set_hachure_angle(angle)
    marker.set_hachure_angle(angle)
    cPencil.set_hachure_angle(angle)
    loop
  end
end

def mouse_dragged
  loop
end

private

def draw_shapes(handy, x, y, w, h)
  minSize = w / 10
  maxSize = min(w, h) / 4
  30.times do
    colour = color(rand(100..200), rand(60..200), rand(100..200), 120)
    fill(colour)
    shape_choice = rand
    if (shape_choice < 0.33)
      handy.rect(x + rand(minSize..w - maxSize),y + rand(minSize..h - maxSize),rand(minSize..maxSize), rand(minSize..maxSize))
    elsif shape_choice < 0.66
      x1 = x + rand(minSize..w - maxSize)
      y1 = y + rand(minSize..h - maxSize)
      x2 = x1 + rand(50..maxSize)
      y2 = y1 + rand(-10..10)
      x3 = (x1 + x2) /  2
      y3 = y1 - rand(minSize..maxSize)
      handy.triangle(x1, y1, x2, y2, x3, y3)
    else
      handy.ellipse(x + rand(minSize..w - maxSize), y + rand(minSize..h - maxSize),rand(minSize..maxSize), rand(minSize..maxSize))
    end
  end
end
