require 'toxiclibs'

W = 1000
H = 600

attr_reader :axiom, :z, :physics

def settings
  size(W, H)
end

def setup
  sketch_title 'Wolfram Circle Growth'
  @axiom = [[0, 1], [0, 2], [1, 2]]
  @z = axiom.flatten.max + 1
  @physics = Physics::VerletPhysics2D.new
  physics.set_drag(0.2)
  # Get id of each node
  uniques = axiom.flatten.uniq
  uniques.each do
    p = Physics::VerletParticle2D.new(TVec2D.randomVector.add(TVec2D.new(W >> 1, H >> 1)))
    physics.addParticle(p)
    physics.addBehavior(Physics::AttractionBehavior2D.new(p, 10, -0.5))
  end
  axiom.each do |node|
    p1 = physics.particles.get(node[0])
    p2 = physics.particles.get(node[1])
    s = Physics::VerletSpring2D.new(p1, p2, 4, 0.5)
    physics.add_spring(s)
  end
end

def draw
  background(color('#FFFFFF'))
  physics.update
  idx = rand(z)
  x, y = *axiom[idx]
  axiom.delete_at(idx)
  axiom << [y, z]
  axiom << [z, x]
  # Manage physics accordingly
  px = physics.particles.get(x) # coordinate of node x
  py = physics.particles.get(y) # coordinate of node y
  pz = Physics::VerletParticle2D.new(px.add(py).scale(0.5)) # create a new particle in between
  s = physics.get_spring(px, py) # find spring between the deleted edge
  physics.remove_spring(s) # remove that spring
  physics.add_particle(pz) # add particle
  physics.add_behavior(Physics::AttractionBehavior2D.new(pz, 10, -0.5)) # attach a repulsion behavior to it
  s1 = Physics::VerletSpring2D.new(py, pz, 4, 0.5) # create spring between 1st new edge
  s2 = Physics::VerletSpring2D.new(pz, px, 4, 0.5) # create spring between 2nd new edge
  physics.add_spring(s1) # add them to physics
  physics.add_spring(s2)
  @z += 1 # increment 'z'
  # Draw springs
  physics.springs.each do |spring|
    line(spring.a.x, spring.a.y, spring.b.x, spring.b.y)
  end
end
