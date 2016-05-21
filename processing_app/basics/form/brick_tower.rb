# Original by Ira Greenberg

# 3D castle tower constructed out of individual bricks.
# Uses the Vect struct and Cube class.

attr_reader :angle, :brick, :bricks_per_layer, :brick_layers
attr_reader :radius, :layer_num, :temp_y

# QUADS = Java::ProcessingCore::PConstants.QUADS

def setup
  sketch_title 'Brick Tower'
  @bricks_per_layer = 16
  @brick_layers = 18
  @brick_width = 60
  @brick_height = 25
  @brick_depth = 25
  @radius = 175.0
  @angle = 0
  @brick = Cubeish.new(self, @brick_width, @brick_height, @brick_depth)
end

def draw
  background 0
  @temp_y = 0
  fill 182, 62, 29
  no_stroke
  lights
  translate(width / 2.0, height * 1.2, -380)    # move viewpoint into position
  rotate_x(-45.radians)                         # tip tower to see inside
  rotate_y(frame_count * PI / 600)              # slowly rotate tower
  brick_layers.times { |i| draw_layer(i) }
end

def draw_layer(layer_num)
  @layer_num = layer_num
  @temp_y -= @brick_height                               # increment rows
  @angle = 360.0 / bricks_per_layer * layer_num / 2.0    # alternate brick seams
  bricks_per_layer.times { draw_bricks }
end

def draw_bricks
  temp_z = DegLut.cos(angle) * radius
  temp_x = DegLut.sin(angle) * radius
  push_matrix
  translate temp_x, temp_y, temp_z
  rotate_y(angle.radians)
  top_layer = layer_num == brick_layers - 1
  brick.create unless top_layer                          # main tower
  pop_matrix
  @angle += 360.0 / bricks_per_layer
end

# The Cubeish class works a little different than the cube in the
# Processing example. SIDES tells you where the negative numbers go.
# We dynamically create each of the PVectors by passing in the
# appropriate signs.
class Cubeish
  attr_reader :app, :vertices, :w, :h, :d

  SIDES = { front: ['-- ', ' - ', '   ', '-  '],
            left: ['-- ', '---', '- -', '-  '],
            right: [' - ', ' --', '  -', '   '],
            back: ['---', ' --', '  -', '- -'],
            top: ['-- ', '---', ' --', ' - '],
            bottom: ['-  ', '- -', '  -', '   ']
          }

  SIGNS = { '-' => -1, ' ' => 1 }

  def initialize(app, width, height, depth)
    @app, @w, @h, @d = app, width, height, depth
    @vertices = {}
    SIDES.each do |side, signs|
      vertices[side] = signs.map do |s|
        s = s.split('').map { |el| SIGNS[el] }
        Vect.new(s[0] * w / 2, s[1] * h / 2, s[2] * d / 2)
      end
    end
  end

  def create
    vertices.each do |_name, vectors|
      app.begin_shape QUADS
      vectors.each { |v| app.vertex(v.x, v.y, v.z) }
      app.end_shape
    end
  end
end

Vect = Struct.new(:x, :y, :z)

def settings
  size 640, 360, P3D
end
