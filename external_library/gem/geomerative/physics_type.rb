require 'toxiclibs'
require 'geomerative'

attr_reader :font, :input, :physics

def settings
  size(1280, 720, P3D)
  smooth
end

def setup
  sketch_title 'Physics Type'
  @input = 'Hello!'
  RG.init(self)
  fnt = RG.load_font(data_path('ReplicaBold.ttf')) # file name
  RG.text_font(fnt, 330) # RFont object, size
  @font = RG.get_text(input) # String to RShape
  RG.set_polygonizer(RCommand::UNIFORMLENGTH)
  RG.set_polygonizer_length(10) # length of segment
  init_physics
  fill(255)
end

def draw
  physics.update
  background(0)
  stroke(255)
  physics.springs.each do |s|
    line(s.a.x, s.a.y, s.b.x, s.b.y)
  end
  physics.particles.each do |p|
    ellipse(p.x, p.y, 3, 3)
  end
end

def init_physics
  @physics = Physics::VerletPhysics2D.new
  # set screen bounds as bounds for physics sim
  physics.set_world_bounds(Toxi::Rect.new(0, 0, width, height))
  # add gravity along positive Y axis
  physics.add_behavior(Physics::GravityBehavior2D.new(TVec2D.new(0, 0.1)))
  # multidimensional array of x and y coordinates
  paths = font.get_points_in_paths
  offset = TVec2D.new(200, 250)
  return if paths.nil?
  paths.length.times do |ii|
    points = paths[ii]
    path_particles = []
    points.length.times do |i|
      p = Physics::VerletParticle2D.new(
        points[i].x + offset.x,
        points[i].y + offset.y
      )
      physics.addParticle(p)
      path_particles << p
      physics.addSpring(
        Physics::VerletSpring2D.new(
          path_particles[i - 1],
          p,
          path_particles[i - 1].distanceTo(p),
          1
        )
      ) if i > 0
    end
    first = path_particles.first
    last = path_particles.last
    physics.add_spring(
      Physics::VerletSpring2D.new(
        first,
        last,
        first.distance_to(last),
        1
      )
    )
    first.lock
  end
end
