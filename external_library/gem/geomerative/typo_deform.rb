# --------- GEOMERATIVE EXAMPLES ---------------
# //////////////////////////////////////////////
# Title   :   TypoGeo_Deform
# Date    :   31/08/2011
# Version :   v0.5
#
# This sketch deforms the text using noise as the underlying
# algorithm. mouseX & mouseY movement will change the amount
# & intensity of the noise values.
# Key 'f' = Switches animation on/off
# Key '+'  & '-' = Changes the diameter of our ellipse.
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
require 'geomerative'
load_library :font_agent

attr_reader :my_font, :my_group, :my_points, :my_text
attr_reader :my_agents, :step, :stop_anime

def settings
  size(800, 350)
  smooth
end

def setup
  sketch_title 'Bubbles'
  background(0)
  @step = 3
  @my_text = 'BUBBLES'
  RG.init(self)
  @my_font = RFont.new(data_path('FreeSans.ttf'), 113, CENTER)
  @stop_anime = false
  RCommand.setSegmentLength(10)
  RCommand.setSegmentator(RCommand::UNIFORMLENGTH)
  @my_points = my_font.toGroup(my_text).getPoints
  @my_agents = my_points.map { |point| FontAgent.new(location: Vec2D.new(point)) }
end

def draw
  translate(400, 205)
  background(0)
  fill(255)
  my_agents.each do |point|
    point.display(step: step)
    point.motion
  end
end

def key_pressed
  case key
  when 'f', 'F'
    @stop_anime = !stop_anime
    stop_anime ? no_loop : loop
  when '+'
    @step += 1
  when '-'
    @step -= 1
  end
end
