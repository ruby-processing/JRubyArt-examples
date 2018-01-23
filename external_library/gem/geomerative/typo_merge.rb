#######################
# --------- GEOMERATIVE EXAMPLES ---------------
#######################
# Title   :   TypoGeo_Merge
# Date    :   31/08/2011
# Version :   v0.5
#
# Merges two words in an random fashion.
# Key 'f' = freezes motion
# key 's' saves the frame in png format
#
# Code adapted from an original idea by Bertrand _fevre
# during the Générative Typos workshop in Lure 2011.
#
# Licensed under GNU General Public License (GPL) version 3.
# http://www.gnu.org/licenses/gpl.html
#
# A series of tutorials for using the Geomerative Library
# developed by Ricard Marxer.
# http://www.ricardmarxer.com/geomerative/
#
# More info on these tutorials and workshops at :
# www.freeartbureau.org/blog
#
# Adapted for JRubyArt by Martin Prout
#######################
require 'geomerative'

attr_reader :my_font, :stop, :xoff, :yoff, :x_inc, :y_inc
TEXT = %w(Merge Design).freeze

def settings
  size(900, 500)
end

def setup
  sketch_title TEXT.join ' '
  RG.init(self)
  @my_font = RFont.new(data_path('FreeSans.ttf'), 230, CENTER)
  @stop = false
  no_fill
  stroke(255)
  stroke_weight(0.5)
  rect_mode(CENTER)
  @xoff = 0.0
  @yoff = 0.0
  @x_inc = 0.01
  @y_inc = 0.015
end

def draw
  background(0, 50)
  displace_x = noise(xoff) * width
  displace_y = noise(yoff) * height
  @xoff += x_inc
  @yoff += y_inc
  translate(width / 2, height / 1.7)
  frequency = map1d(displace_x, (300..500), (3..200))
  RCommand.set_segment_length(frequency)
  my_points = my_font.to_group(TEXT[0]).get_points
  begin_shape
  my_points.each do |point|
    vertex(point.x, point.y)
    rotation = map1d(displace_y, (0..height), (0..TWO_PI))
    push_matrix
    translate(point.x, point.y)
    rotate(rotation)
    size = frequency / 6
    rect(0, 0, size, size)
    pop_matrix
  end
  end_shape
  frequency2 = map1d(displace_x, (300..500), (200..3))
  RCommand.set_segment_length(frequency2)
  my_points = my_font.to_group(TEXT[1]).get_points
  begin_shape
  my_points.each do |point|
    vertex(point.x, point.y)
    size = frequency2 / 7
    ellipse(point.x, point.y, size, size)
  end
  end_shape
end

def key_pressed
  case key
  when 'f', 'F'
    @stop = !stop
    stop ? no_loop : loop
  when 's', 'S'
    save_frame('000_###.png')
  end
end
