# Interactive Toroid
# by Ira Greenberg.
#
# Illustrates the geometric relationship between Toroid, Sphere, and Helix
# 3D primitives, as well as lathing principal.
#
# Instructions:
# 	UP arrow key ____ pts++
# 	DOWN arrow key __ pts--
# 	LEFT arrow key __ segments--
# 	RIGHT arrow key _ segments++
# 	'a' key _________ toroid radius--
# 	's' key _________ toroid radius++
# 	'z' key _________ initial polygon radius--
# 	'x' key _________ initial polygon radius++
# 	'w' key _________ toggle wireframe/solid shading
# 	'h' key _________ toggle sphere/helix

def setup
  sketch_title 'Toroid'
  @pts = 40
  @angle = 0.0
  @radius = 60.0
  @segments = 60.0
  @lathe_angle = 0.0
  @lathe_radius = 100.0
  @is_wireframe = false
  @is_helix = false
  @helix_offset = 5.0
end

def draw
  background 50, 64, 42
  lights
  if @is_wireframe
    stroke 255, 255, 150
    no_fill
  else
    no_stroke
    fill 150, 195, 125
  end
  translate width / 2, height / 2, -100
  rotate_x frame_count * PI / 150
  rotate_y frame_count * PI / 170
  rotate_z frame_count * PI / 90
  vertices = []
  vertices2 = []
  0.upto(@pts) do |i|
    vertices2[i] = Vec3D.new
    vertices[i] = Vec3D.new
    vertices[i].x = @lathe_radius + Math.sin(@angle.radians) * @radius
    if @is_helix
      vertices[i].z =
        Math.cos(@angle.radians) * @radius - (@helix_offset * @segments) / 2
    else
      vertices[i].z = Math.cos(@angle.radians) * @radius
    end
    @angle += 360.0 / @pts
  end
  @lathe_angle = 0
  0.upto(@segments) do |i|
    begin_shape QUAD_STRIP
    (0..@pts).each do |j|
      vertices2[j].to_vertex(renderer) if i > 0
      vertices2[j].x = Math.cos(@lathe_angle.radians) * vertices[j].x
      vertices2[j].y = Math.sin(@lathe_angle.radians) * vertices[j].x
      vertices2[j].z = vertices[j].z
      vertices[j].z += @helix_offset if @is_helix
      vertices2[j].to_vertex(renderer)
    end
    @lathe_angle += (@is_helix ? 720 : 360) / @segments
    end_shape
  end
end

def key_pressed
  case key
  when CODED
    case keyCode
    when UP
      @pts += 1 if @pts < 40    
    when DOWN
      @pts -= 1 if @pts > 3  
    when RIGHT      
      @segments += 1 if @segments < 80
     when LEFT
      @segments -= 1 if @segments > 3
    end
  when 's'
    @lathe_radius += 1 
  when 'a'
    @lathe_radius -= 1 if @lathe_radius > 0
  when 'x'
    @radius += 1
  when 'z'
    @radius -= 1 if @radius > 10
  when 'w'
    @is_wireframe = !@is_wireframe
  when 'h'
    @is_helix = !@is_helix
  end
end

def settings
  size 640, 360, P3D
end

def renderer
  @renderer ||= AppRender.new(self)
end
