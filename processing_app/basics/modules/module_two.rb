# Drawolver: draw 2D & revolve 3D

# Example to show how to use the VecMath library.
# Also the Array is extended to yield one_of_each using a module
# pair of pts. See the drawolver library. Also features the use each_cons, 
# possibly a rare use for this ruby Enumerable method?
# 2010-03-22 - fjenett (last revised by monkstone 2015-10-17)

attr_reader :drawing_mode, :points, :rot_x, :rot_y, :vertices, :renderer

module ExtendedArray
  # send one item from each array, expects array to be 2D:
  # array [[1,2,3], [a,b,c]] sends
  # [1,a] , [2,b] , [3,c]
  def one_of_each(&block)
    i = 0
    one = self[0]
    two = self[1]
    mi = one.length > two.length ? two.length : one.length
    while i < mi do
      yield(one[i], two[i])
      i += 1
    end
  end
end

def setup 
  sketch_title 'Module Two'
  @renderer = GfxRender.new(self.g)
  frame_rate 30 
  reset_scene
end

def draw  
  background 0    
  if (!drawing_mode)      
    translate(width / 2, height / 2)
    rotate_x rot_x
    rotate_y rot_y
    @rot_x += 0.01
    @rot_y += 0.02
    translate(-width/2, -height/2)
  end 
  no_fill
  stroke 255
  points.each_cons(2) { |ps, pe| line ps.x, ps.y, pe.x, pe.y }

  return if drawing_mode    
  stroke 125
  fill 120
  lights 
  ambient_light 120, 120, 120
  vertices.each_cons(2) do |r1, r2|
    begin_shape(TRIANGLE_STRIP)
    ext_array = [r1,r2].extend ExtendedArray # extend an instance of Array
    ext_array.one_of_each do |v1, v2|          
      v1.to_vertex(renderer)
      v2.to_vertex(renderer)
    end
    end_shape 
  end
end

def reset_scene 
  @drawing_mode = true
  @points = []
  @rot_x = 0.0
  @rot_y = 0.0
end

def mouse_pressed
  reset_scene
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_dragged
  points << Vec3D.new(mouse_x, mouse_y)
end

def mouse_released
  points << Vec3D.new(mouse_x, mouse_y)
  recalculate_shape
end

def recalculate_shape  
  @vertices = []
  points.each_cons(2) do |ps, pe|   
    b = points.last - points.first
    len = b.mag
    b.normalize!   
    a = ps - points.first   
    dot = a.dot b   
    b = b * dot   
    normal = points.first + b    
    c = ps - normal
    nlen = c.mag    
    vertices << []    
    (0..TAU).step(PI/15) do |ang|     
      e = normal + c * Math.cos(ang)
      e.z = c.mag * Math.sin(ang)      
      vertices.last << e
    end
  end
  @drawing_mode = false
end

def settings
  size 1024, 768, P3D
end
