# Inheritance
#
# A class can be defined using another class as a foundation. In object-oriented
# programming terminology, one class can inherit fields and methods from another.
# An object that inherits from another is called a subclass, and the object it
# inherits from is called a superclass. A subclass extends the superclass.
# see also inheritance_two for the use of hash args and inheritance that
# avoids the inherited class call to super

def settings
  size 640, 360
end

def setup
  sketch_title 'Inheritance'
  @arm = SpinArm.new self, width / 2, height / 2, 0.01
  @spots = SpinSpots.new self, width / 2, height / 2, -0.02, 90.0
end

def draw
  background 204
  @arm.display
  @spots.display
end

# class Spin
class Spin
  attr_accessor :x, :y, :speed
  attr_reader :app, :angle

  def initialize(app, x, y, s)
    @app, @x, @y = app, x, y
    @speed = s
    @angle = 0.0
  end

  def update
    @angle += speed
  end
end

# class SpinArm
class SpinArm < Spin
  # NB: initialize inherited from Spin class

  def display
    app.stroke_weight 1
    app.stroke 0
    app.push_matrix
    app.translate x, y
    update
    app.rotate angle
    app.line 0, 0, 165, 0
    app.pop_matrix
  end
end

# class SpinSpots

class SpinSpots < Spin
  attr_accessor :dim
  def initialize(app, x, y, s, d)
    super(app, x, y, s)
    @dim = d
  end

  def display
    app.no_stroke
    app.push_matrix
    app.translate x, y
    update
    app.rotate angle
    app.ellipse(-dim / 2, 0, dim, dim)
    app.ellipse(dim / 2, 0, dim, dim)
    app.pop_matrix
  end
end
