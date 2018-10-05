load_library :handy, :gicentreUtils

java_import 'org.gicentre.handy.HandyPresets'
java_import 'org.gicentre.handy.HandyRenderer'
java_import 'org.gicentre.utils.FrameTimer'
##****************************************************************************************
# Simple sketch to test handy 3d shape building. 'H' toggles sketchiness on or off. 'A'
#  changes hachure angle. Left and right arrow keys change vertex overshoot. Up and down
#  arrows change degree of sketchiness.
#  @author Jo Wood, giCentre, City University London.
#  @version JRubyArt translation by Martin Prout, now uses ArcBall
##****************************************************************************************

# this file is part of Handy sketchy drawing library. Handy is free software: you can
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
attr_reader :h, :is_handy, :roughness, :timer, :overshoot, :angle
attr_reader :xmag, :ymag, :newXmag, :newYmag, :diff
# ---------------------------- Processing methods -----------------------------
def settings
  size(640, 360, P3D)
  pixelDensity(displayDensity) # Use platform's maximum display density.
end

def setup
  sketch_title 'Vertex 3D Test'
  ArcBall.init(self)
  @xmag = @ymag = @newXmag = @newYmag = 0
  @timer = FrameTimer.new
  @roughness = 1.5
  @overshoot = 1.1
  @angle = 45
  @h = HandyPresets.createMarker(self)
  @is_handy = true
  h.setRoughness(roughness)
  h.setHachureAngle(angle)
  h.setHachurePerturbationAngle(0)
  fill(180,80,80)
end

def draw
  background(235, 215, 182)
  timer.displayFrameRate
  h.setSeed(1969)
  h.setStrokeWeight(4)
  h.setStrokeColour(color(0))
  lengthA = 100
  lengthB = 60
  h.beginShape(QUADS)
  h.vertex(-lengthA,  lengthA,  lengthB)
  h.vertex( lengthA,  lengthA,  lengthB)
  h.vertex( lengthA, -lengthA,  lengthB)
  h.vertex(-lengthA, -lengthA,  lengthB)

  h.vertex( lengthA,  lengthA,  lengthB)
  h.vertex( lengthA,  lengthA, -lengthB)
  h.vertex( lengthA, -lengthA, -lengthB)
  h.vertex( lengthA, -lengthA,  lengthB)

  h.vertex( lengthA,  lengthA, -lengthB)
  h.vertex(-lengthA,  lengthA, -lengthB)
  h.vertex(-lengthA, -lengthA, -lengthB)
  h.vertex( lengthA, -lengthA, -lengthB)

  h.vertex(-lengthA,  lengthA, -lengthB)
  h.vertex(-lengthA,  lengthA,  lengthB)
  h.vertex(-lengthA, -lengthA,  lengthB)
  h.vertex(-lengthA, -lengthA, -lengthB)

  h.vertex(-lengthA,  lengthA, -lengthB)
  h.vertex( lengthA,  lengthA, -lengthB)
  h.vertex( lengthA,  lengthA,  lengthB)
  h.vertex(-lengthA,  lengthA,  lengthB)

  h.vertex(-lengthA, -lengthA, -lengthB)
  h.vertex( lengthA, -lengthA, -lengthB)
  h.vertex( lengthA, -lengthA,  lengthB)
  h.vertex(-lengthA, -lengthA,  lengthB)
  h.endShape

  # Pencil guide lines.
  h.setStrokeWeight(2)
  h.setStrokeColour(color(0,100))
  h.line(-lengthA*overshoot,lengthA,lengthB, lengthA*overshoot,lengthA,lengthB)
  h.line( lengthA,lengthA*overshoot, lengthB, lengthA, -lengthA*overshoot, lengthB)
  h.line( lengthA*overshoot, -lengthA,  lengthB,-lengthA*overshoot, -lengthA,  lengthB)
  h.line(-lengthA, -lengthA*overshoot,  lengthB,-lengthA,  lengthA*overshoot,  lengthB)

  h.line( lengthA,  lengthA,  lengthB*overshoot, lengthA,  lengthA, -lengthB*overshoot)
  h.line( lengthA,  lengthA*overshoot, -lengthB, lengthA, -lengthA*overshoot, -lengthB)
  h.line( lengthA, -lengthA, -lengthB*overshoot, lengthA, -lengthA,  lengthB*overshoot)

  h.line( lengthA*overshoot,  lengthA, -lengthB,-lengthA*overshoot,  lengthA, -lengthB)
  h.line(-lengthA,  lengthA*overshoot, -lengthB,-lengthA, -lengthA*overshoot, -lengthB)
  h.line(-lengthA*overshoot, -lengthA, -lengthB, lengthA*overshoot, -lengthA, -lengthB)

  h.line(-lengthA,  lengthA, -lengthB*overshoot,-lengthA,  lengthA,  lengthB*overshoot)
  h.line(-lengthA, -lengthA,  lengthB*overshoot,-lengthA, -lengthA, -lengthB*overshoot)
end

def key_pressed
  case key
  when 'h', 'H'
    @is_handy = !is_handy
    h.set_is_handy(is_handy)
  when 'a', 'A'
    @angle += 1
    h.setHachureAngle(angle)
  else
    return unless key == CODED
  end
  case key_code
  when UP
    @roughness *= 1.1
    h.setRoughness(roughness)
  when DOWN
    @roughness *= 0.9
    h.setRoughness(roughness)
  when LEFT
    @overshoot *= 0.99 if overshoot > 1.0
  when RIGHT
    @overshoot *= 1.01
  end
end
