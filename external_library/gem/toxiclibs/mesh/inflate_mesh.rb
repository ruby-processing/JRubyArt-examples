
require 'toxiclibs'
# A JRubyArt sketch needs refactoring for JRubyArt
#
# Copyright (c) 2010 Karsten Schmidt & JRubyArt version Martin Prout 2015
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

attr_reader :mesh, :gfx, :physics, :render, :box, :pm, :inflate

def settings
  size(680, 382, P3D)
end

def setup
  sketch_title 'Inflate Mesh'
  Processing::ArcBall.init(self)
  @gfx = Gfx::ToxiclibsSupport.new(self)
  init_physics
end

def draw
  physics.update
  box.vertices.values.each { |v| v.set(physics.particles.get(v.id)) }
  box.center(nil)
  box.vertices.values.each { |v| physics.particles.get(v.id).set(v) }
  box.compute_face_normals
  box.face_outwards
  box.compute_vertex_normals
  background(51)
  no_fill
  lights
  directional_light(255, 255, 255, -200, 1000, 500)
  specular(255)
  shininess(16)
  gfx.origin(Vec3D.new, 50)
  fill(192)
  no_stroke
  gfx.mesh(box, true, 5)
end

def init_physics
  @box = WETriangleMesh.new
  # create a simple start mesh
  # box.addMesh(
  #   Toxi::Cone.new(
  #     TVec3D.new(0, 0, 0),
  #     TVec3D.new(0, 1, 0),
  #     10,
  #     50,
  #     100
  #   ).to_mesh(4)
  # )
  box.add_mesh(AABB.new(TVec3D.new, 50).to_mesh)
  # then subdivide a few times...
  4.times { box.subdivide }
  @physics = Physics::VerletPhysics3D.new
  physics.set_world_bounds(AABB.new(TVec3D.new, 180))
  # turn mesh vertices into physics particles
  box.vertices.values.each do |v|
    physics.add_particle(Physics::VerletParticle3D.new(v))
  end
  # turn mesh edges into springs
  box.edges.values.each do |e|
    a = physics.particles.get((e.a).id)
    b = physics.particles.get((e.b).id)
    physics.add_spring(
      Physics::VerletSpring3D.new(a, b, a.distance_to(b), 0.005)
    )
  end
end

def key_pressed
  case key
  when 'r', 'R'
    init_physics
  end
end

def mouse_pressed
  @inflate = Physics::AttractionBehavior3D.new(TVec3D.new, 400, -0.3, 0.001)
  physics.add_behavior(inflate)
end

def mouse_released
  physics.remove_behavior(inflate)
end
