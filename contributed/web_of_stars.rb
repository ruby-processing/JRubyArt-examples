# encoding: utf-8
# After a sketch by Jerome Herr
# see http://www.openprocessing.org/sketch/147466
attr_reader :save, :ball_collection, :fc
NUM = 180

def settings
  size 800, 600
end

def setup
  sketch_title 'Web of Stars'
  background(0)
  @ball_collection = []
  create_stuff
  @save = false
  @fc = 0
  @edge = 200
end

def draw
  fill(0, 20)
  no_stroke
  rect(0, 0, width, height) # partially clear the frame
  ball_collection.map(&:run)
  if save
    save_frame("image-####.tif") if (frame_count < fc + (240 * 3))
  end
end

def key_pressed
  @fc = frame_count
  @save = true
end

def mouse_released
  background(0)
  create_stuff
end

def create_stuff
  @ball_collection = (0..NUM).map do
    origin = Vec2D.new(rand(NUM..width - NUM), rand(NUM..height - NUM))
    radius = rand(50..150)
    Ball.new(
      org: origin,
      loc: Vec2D.new(origin.x + radius, origin.y),
      radius: radius,
      dir: (rand > 0.5) ? -1 : 1,
      offset: rand(TWO_PI)
    )
  end
end

# Ball class has access to sketch methods via Processing::Proxy module
class Ball
  include Processing::Proxy
  attr_reader :org, :loc, :sz, :theta, :radius, :offset, :s, :dir, :d

  def initialize(org:, loc:, radius:, dir:, offset:)
    @org = org
    @loc = loc
    @radius = radius
    @dir = dir
    @offset = offset
    @sz = 10
    @d = 60
    @theta = 0
  end

  def run
    move
    display
    line_between
  end

  def move
    loc.x = org.x + sin(theta + offset) * radius
    loc.y = org.y + cos(theta + offset) * radius
    @theta += (0.0523 / 2 * dir)
  end

  def line_between
    ball_collection.each do |other|
      distance = loc.dist(other.loc)
      if distance < d
        stroke(color('#ffffff'), 150)
        line(loc.x, loc.y, other.loc.x, other.loc.y)
      end
    end
  end

  def display
    no_stroke
    5.times do |i|
      fill(255, i * 50)
      ellipse(loc.x, loc.y, sz - 2 * i, sz - 2 * i)
    end
  end
end
