# Custom Cube Class
class Cube
  include Processing::Proxy
  
  # Colors are hardcoded
  BOUNDS = 300
  COLORS = [0,  51,  102,  153,  204,  255]
 
  # Position, velocity Vectors
  attr_reader :position, :velocity, :rotation, :vertices, :w, :h, :d
  attr_reader :boundary
  def initialize(dim)
    @w = dim
    @h = dim
    @d = dim
    @boundary = Boundary.new(-BOUNDS/2, BOUNDS/2)
    @vertices = []
    # Start in center
    @position = Vec3D.new
    # Random velocity Vec3D
    @velocity = Vec3D.random
    # Random rotation
    @rotation = Vec3D.new(rand(40..100), rand(40..100), rand(40..100))
    
    # cube composed of 6 quads
    #front
    vertices << [-w/2, -h/2, d/2]
    vertices << [w/2, -h/2, d/2]
    vertices << [w/2, h/2, d/2]
    vertices << [-w/2, h/2, d/2]
    #left
    vertices << [-w/2, -h/2, d/2]
    vertices << [-w/2, -h/2, -d/2]
    vertices << [-w/2, h/2, -d/2]
    vertices << [-w/2, h/2, d/2]
    #right
    vertices << [w/2, -h/2, d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [w/2, h/2, d/2]
    #back
    vertices << [-w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [-w/2, h/2, -d/2]
    #top
    vertices << [-w/2, -h/2, d/2]
    vertices << [-w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, -d/2]
    vertices << [w/2, -h/2, d/2]
    #bottom
    vertices << [-w/2, h/2, d/2]
    vertices << [-w/2, h/2, -d/2]
    vertices << [w/2, h/2, -d/2]
    vertices << [w/2, h/2, d/2]
  end 
  
  # Cube shape itself
  def draw_cube
    # Draw cube
    COLORS.length.times do |i|
      fill(COLORS[i])
      begin_shape(QUADS)
        4.times do |j|
          vertex(*vertices[j + 4 * i]) # splat vertices
        end
      end_shape
    end
  end
  
  # Update location
  def update
    @position += velocity
    
    # Check wall collisions
    unless boundary.include? position.x
      velocity.x *= -1
    end
    unless boundary.include? position.y
      velocity.y *= -1
    end
    unless boundary.include? position.z
      velocity.z *= -1
    end
  end
  
  
  # Display method
  def display
    push_matrix
    translate(position.x, position.y, position.z)
    rotate_x(frame_count * PI / rotation.x)
    rotate_y(frame_count * PI / rotation.y)
    rotate_z(frame_count * PI /  rotation.z)
    no_stroke
    draw_cube # Farm out shape to another method
    pop_matrix
  end
end

# Abstract boundary checking to this
# lightweight class
#
  
Boundary = Struct.new(:lower, :upper) do
  def include? x
    (lower...upper).cover? x
  end
end
