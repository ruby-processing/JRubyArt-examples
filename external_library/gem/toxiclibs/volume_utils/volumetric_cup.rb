# NoiseSurface demo showing how to utilize the IsoSurface class to efficiently
# visualise volumetric data, in this case using 3D SimplexNoise. The demo also
# shows how to save the generated mesh as binary STL file (or alternatively in
# OBJ format) for later use in other 3D tools/digital fabrication.
#
# Further classes for the toxi.volume package are planned to easier draw
# and manipulate volumetric data.
#
# Key controls:
# w : toggle rendering style between shaded/wireframe
# s : save model as STL & quit
# 1-9 : adjust brush density
# a-z : adjust density threshold for calculating surface
# -/= : adjust zoom
#
# Copyright (c) 2009 Karsten Schmidt
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
require 'toxiclibs'
include_package 'toxi.math.waves' # for SineWave

DIMX = 96
DIMY = 96
DIMZ = 128
NS = 0.03
SCALE = TVec3D.new(256, 256, 384)
Z_STEP = 0.005

attr_reader :gfx, :do_save, :mesh, :isurface, :volume, :brush, :brush_size
attr_reader :iso_threshold, :curr_scale, :density, :spin, :curr_z

def settings
  size(1024, 768, P3D)
end

def setup
  sketch_title 'Volumetric Cup'
  @isWireframe = false
  @do_save = false
  @gfx = Gfx::ToxiclibsSupport.new(self)
  stroke_weight(0.5)
  @volume = VolumetricSpaceArray.new(SCALE, DIMX, DIMY, DIMZ)
  @brush = RoundBrush.new(volume, SCALE.x / 2)
  @brush_size = SineWave.new(
    -HALF_PI,
    2 * TWO_PI * Z_STEP,
    SCALE.x * 0.03,
    SCALE.x * 0.06
  )
  @isurface = ArrayIsoSurface.new(volume)
  @mesh = TriangleMesh.new
  @iso_threshold = 0.1
  @curr_scale = 1
  @density = 0.5
  @spin = 8
  @curr_z = 0
end

def draw
  brush.setSize(brush_size.update)
  offsetZ = -SCALE.z + curr_z * SCALE.z * 2.6666
  curr_radius = SCALE.x * 0.4 * sin(curr_z * PI)
  (0..TWO_PI).step(PI / 2) do |t|
    brush.drawAtAbsolutePos(
      TVec3D.new(
        curr_radius * cos(t + curr_z * spin),
        curr_radius * sin(t + curr_z * spin),
        offsetZ
      ),
      density
    )
    brush.drawAtAbsolutePos(
      TVec3D.new(
        curr_radius * cos(t - curr_z * spin),
        curr_radius * sin(t - curr_z * spin),
        offsetZ
      ),
      density
    )
  end
  @curr_z += Z_STEP
  volume.close_sides
  isurface.reset
  isurface.computeSurfaceMesh(mesh, iso_threshold)
  if do_save
    # save mesh as STL or OBJ file
    cup_stl = 'cup%d.stl'
    mesh.saveAsSTL(data_path(format(cup_stl, millis / 1_000)))
    @do_save = false
    exit
  end
  background(128)
  translate(width / 2, height / 2, 0)
  light_specular(230, 230, 230)
  directional_light(255, 255, 255, 1, 1, -1)
  shininess(1.0)
  rotate_x(-0.4)
  rotate_y(frame_count * 0.05)
  scale(curr_scale)
  no_stroke
  gfx.mesh(mesh)
end

def key_pressed
  case key
  when '-'
    @curr_scale = max(curr_scale - 0.1, 0.5) # processing method
  when '='
    @curr_scale = min(curr_scale + 0.1, 10) # processing method
  when 's'
    @do_save = true
  when '1'..'9'
    density = -0.5 + key.to_i * 0.1
    puts density
  when '0'
    @density = 0.5
  when 'a'..'z'
    @iso_threshold = (key.ord - 'a'.ord) * 0.019 + 0.01
  end
end
