
#
# This example implements a custom VolumetricSpace using an implicit function
# to calculate each voxel. This is slower than the default array or HashMap
# based implementations, but also has much less memory requirements and so might
# be an interesting and more viable approach for very highres voxel spaces
# (e.g. >32 million voxels). This implementation here also demonstrates how to
# achieve an upper boundary on the iso value (in addition to the one given and
# acting as lower threshold when computing the iso surface)
#
# Usage:
# drag mouse to rotate camera
# mouse wheel zoom in/out
# l: apply laplacian mesh smooth
#
#

#
# Copyright (c) 2010 Karsten Schmidt & JRubyArt version Martin Prout 2015
#
# This library is free software you can redistribute it and/or
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

RES = 64
ISO = 0.2
MAX_ISO = 0.66

attr_reader :mesh, :vbo, :curr_zoom, :implicit

def settings
  size(720, 720, P3D)
end

def setup
  sketch_title 'Implicit Surface'
  Processing::ArcBall.init(self)
  @vbo = Gfx::MeshToVBO.new(self)
  @curr_zoom = 1
  vol = EvaluatingVolume.new(TVec3D.new(400, 400, 400), RES, RES, RES, MAX_ISO)
  surface = Volume::HashIsoSurface.new(vol)
  @mesh = WETriangleMesh.new
  surface.compute_surface_mesh(mesh, ISO)
  @is_wire_frame = false
  no_stroke
  @implicit = vbo.mesh_to_shape(mesh, true)
  implicit.set_fill(color(222, 222, 222))
  implicit.set_ambient(color(50, 50, 50))
  implicit.set_shininess(color(10, 10, 10))
  implicit.set_specular(color(50, 50, 50))
end

def draw
  background(0)
  lights
  define_lights
  shape(implicit)
end

def key_pressed
  case key
  when 'l', 'L'
    LaplacianSmooth.new.filter(mesh, 1)
    @implicit = vbo.mesh_to_shape(mesh, true)
    # new mesh so need to set finish
    implicit.set_fill(color(222, 222, 222))
    implicit.set_ambient(color(50, 50, 50))
    implicit.set_shininess(color(10, 10, 10))
    implicit.set_specular(color(50, 50, 50))
  when 's', 'S'
    save_frame('implicit.png')
  when 'p', 'P'
    no_loop
    pm = Gfx::POVMesh.new(self)
    file = java.io.File.new('implicit.inc')
    pm.begin_save(file)
    pm.set_texture(Gfx::Textures::WHITE)
    pm.saveAsPOV(mesh, true)
    pm.end_save
    exit
  end
end

def define_lights
  ambient_light(50, 50, 50)
  point_light(30, 30, 30, 200, -150, 0)
  directional_light(0, 30, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, -0.5, PI / 2, 2)
end

# Custom evaluating Volume Class
class EvaluatingVolume < Volume::VolumetricSpace
  attr_reader :upper_bound
  FREQ = Math::PI * 3.8

  def initialize(scal_vec, resX, resY, resZ, upper_limit)
    super(scal_vec, resX, resY, resZ)
    @upper_bound = upper_limit
  end

  def clear
    # nothing to do here
  end

  def getVoxelAt(i)
    get_voxel(i % resX, (i % sliceRes) / resX, i / sliceRes)
  end

  def get_voxel(x, y, z) # can't overload so we renamed
    out = ->(val, res) { val <= 0 || val >= res }
    return 0 if out.call(x, resX1) || out.call(y, resY1) || out.call(z, resZ1)
    value = ->(val, res) { val * 1.0 / res - 0.5 }
    function0 = lambda do |x, y, z, c|
      cos(x * c) * sin(y * c) + cos(y * c) * sin(z * c) + cos(z * c) * sin(x * c)
    end
    function1 = lambda do |x, y, z, c|
      3 * x**2 + 3 * y**2 - (3 * x**2 - y**2) * y + z**3
    end
    val = function1.call(value.call(x, resX),value.call(y, resY), value.call(z, resZ), FREQ)
    # val = cos(xx * FREQ) * sin(yy * FREQ) + cos(yy * FREQ) * sin(zz * FREQ) + cos(zz * FREQ) * sin(xx * FREQ)
    # 3*pow(x,2) + 3*pow(y,2) - (3*pow(x,2) - pow(y,2))*y + pow(z,3)
    return 0 if val > upper_bound
    val
  end
end
