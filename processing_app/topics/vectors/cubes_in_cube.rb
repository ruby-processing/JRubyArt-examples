#
# Cubes Contained Within a Cube
# by Ira Greenberg.
#
# Collision detection against all
# outer cube's surfaces.
#

# 20 little internal cubes
load_library 'cube'

# Size of outer cube
BOUNDS = 300
CUBE_NO = 20
attr_reader :cubies
# using java_alias to give signatures to overloaded java methods
# in the sketch class
java_alias :background_int, :background, [Java::int]
java_alias :stroke_int, :stroke, [Java::int]

def settings
  size(640, 360, P3D)
  smooth 8
end

def setup
  sketch_title 'Cubes in Cube'
  @cubies = (0..CUBE_NO).map { Cube.new(rand(5..15)) }
end

def draw
  background_int(50)
  lights
  # Center in display window
  translate(width/2, height/2, -130)
  # Rotate everything, including external large cube
  rotate_x(frame_count * 0.001)
  rotate_y(frame_count * 0.002)
  rotate_z(frame_count * 0.001)
  stroke_int(255)
  # Outer transparent cube, just using box method
  no_fill
  box(BOUNDS)
  # Move and rotate cubies
  cubies.each(&:update)
  cubies.each(&:display)
end
