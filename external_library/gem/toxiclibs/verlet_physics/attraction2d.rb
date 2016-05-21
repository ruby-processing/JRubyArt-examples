require 'toxiclibs'

NUM_PARTICLES = 750

attr_reader :physics, :mouse_attractor, :mouse_pos

def settings
  size(680, 382, P3D)
end

def setup
  sketch_title 'Attraction 2D'
  # setup physics with 10% drag
  @physics = Physics::VerletPhysics2D.new
  physics.set_drag(0.05)
  physics.set_world_bounds(Toxi::Rect.new(0, 0, width, height))
  # the NEW way to add gravity to the simulation, using behaviors
  physics.add_behavior(Physics::GravityBehavior2D.new(TVec2D.new(0, 0.15)))
end

def add_particle
  p = Physics::VerletParticle2D.new(
    TVec2D.random_vector.scale(5).add_self(width / 2, 0)
  )
  physics.add_particle(p)
  # add a negative attraction force field around the new particle
  physics.add_behavior(Physics::AttractionBehavior2D.new(p, 20, -1.2, 0.01))
end

def draw
  background(255, 0, 0)
  no_stroke
  fill(255)
  add_particle if physics.particles.size < NUM_PARTICLES
  physics.update
  physics.particles.each do |p|
    ellipse(p.x, p.y, 5, 5)
  end
end

def mouse_pressed
  @mouse_pos = TVec2D.new(mouse_x, mouse_y)
  # create a new positive attraction force field around the mouse position
  # (radius=250px)
  @mouse_attractor = Physics::AttractionBehavior2D.new(mouse_pos, 250, 0.9)
  physics.add_behavior(mouse_attractor)
end

def mouse_dragged
  # update mouse attraction focal point
  mouse_pos.set(mouse_x, mouse_y)
end

def mouse_released
  # remove the mouse attraction when button has been released
  physics.remove_behavior(mouse_attractor)
end
