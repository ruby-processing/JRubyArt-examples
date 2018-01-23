# --------- GEOMERATIVE EXAMPLES ---------------
# //////////////////////////////////////////////
# Title   :   TypoGeo_ExtraBright
# Date    :   31/08/2011
# Version :   v0.5
#
# Interactive work which you need to play with.
#
# Code adapted from an original idea by Stéphane Buellet
# http://www.chevalvert.fr/
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
# translated for JRubyArt by Martin Prout
require 'geomerative'
load_library :f_agent

attr_reader :my_agents

def settings
  size(900, 350)
end

def setup
  sketch_title 'Extra Bright'
  background(0)
  my_text = 'EXTRA BRIGHT'
  x_incr = 0.000005
  y_incr = 0.000008
  RG.init(self)
  my_font = RFont.new(data_path('FreeSans.ttf'), 97, CENTER)
  RCommand.set_segment_length(1)
  RCommand.set_segmentator(RCommand::UNIFORMLENGTH)
  @my_agents = my_font.to_group(my_text).get_points.map do |point|
    FontAgent.new(
      loc: Vec2D.new(point.x, point.y),
      increment: Vec2D.new(x_incr, y_incr)
    )
  end
end

def draw
  translate(width / 2, height / 2)
  background(0)
  my_agents.each do |point|
    m_point = point.motion
    xr = (((100 / m_point) * 2) + mouse_x) - width / 2
    yr = (((100 / m_point) * 2) + mouse_y) - height / 2
    point.display(xr: xr, yr: yr, m_point: m_point)
  end
end

def key_pressed
  no_loop
end
