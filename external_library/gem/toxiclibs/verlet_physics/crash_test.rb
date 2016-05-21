require 'toxiclibs'

attr_reader :gfx, :physics, :mesh

Vect = Struct.new(:x, :y, :z)
UP = Vect.new(0, 1, 0)
EYE = Vect.new(-100, -50, 80)

def settings
  size(680, 382, P3D)
end

def setup
  sketch_title 'Crash Test'
  @gfx = Gfx::ToxiclibsSupport.new(self)
  init_physics
end

def draw
  physics.update
  # update mesh vertices based on the current particle positions
  mesh.vertices.values.each do |v|
    v.set(physics.particles.get(v.id))
  end
  # update mesh normals
  mesh.compute_face_normals
  # setup lighting
  background(51)
  lights
  directional_light(255, 255, 255, -200, 1000, 500)
  specular(255)
  shininess(16)
  # point camera at mesh centroid (ruby can duck-type)
  kamera(
    eye: EYE,
    center: mesh.compute_centroid,
    up: UP
  )
  # draw coordinate system
  gfx.origin(TVec3D.new, 50)
  # draw physics bounding box
  stroke(255, 80)
  no_fill
  gfx.box(physics.get_world_bounds)
  # draw car
  fill(160)
  no_stroke
  gfx.mesh(mesh, false, 0)
end

def init_physics
  @physics = Physics::VerletPhysics3D.new
  @mesh = WETriangleMesh.new.addMesh(
    STLReader.new.load_binary(
      create_input('audi.stl'), 
      'car', 
      STLReader::WEMESH
    )
  )
  # properly orient and scale mesh
  mesh.rotate_x(HALF_PI)
  mesh.scale(8)
  # adjust physics bounding box based on car (but bigger)
  # and align car with bottom of the new box
  bounds = mesh.get_bounding_box
  ext = bounds.get_extent
  min = bounds.sub(ext.scale(4, 3, 2))
  max = bounds.add(ext.scale(4, 3, 2))
  physics.set_world_bounds(AABB.from_min_max(min, max))
  mesh.translate(TVec3D.new(ext.scale(3, 2, 0)))
  # set gravity along negative X axis with slight downward
  physics.add_behavior(
    Physics::GravityBehavior3D.new(TVec3D.new(-0.1, 0.001, 0))
  )
  # turn mesh vertices into physics particles
  mesh.vertices.values.each do |v|
    physics.add_particle(Physics::VerletParticle3D.new(v))
  end
  # turn mesh edges into springs
  mesh.edges.values.each do |e|
    a = physics.particles.get(e.a.id)
    b = physics.particles.get(e.b.id)
    physics.add_spring(Physics::VerletSpring3D.new(a, b, a.distance_to(b), 1))
  end
end

def key_pressed
  return unless key == 'r'
  init_physics
end
