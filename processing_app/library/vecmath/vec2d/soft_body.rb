########
# Soft Body by Ira Greenberg
# Softbody dynamic simulation using curve_vertex
# and curve_tightness (features Vec2D to_curve_vertex)
########
attr_reader :accel, :center, :frequency, :radius, :rot_angle
attr_reader :organic_constant, :nodes, :angle, :node_start
SPRINGING = 0.0009
DAMPING = 0.98
NODES = 5

def setup
  sketch_title 'Soft Body'
  init_nodes
  no_stroke
  frame_rate 30
end

def init_nodes
  @accel = Vec2D.new
  @center = Vec2D.new(width / 2, height / 2)
  @radius = 45
  @organic_constant = 1
  @rot_angle = -90
  @nodes = Array.new(NODES, Vec2D.new)
  @frequency = (0...NODES).map { rand(5..12) }
  @angle = Array.new(NODES, 0)
end

def draw
  fill(0, 100)
  rect(0, 0, width, height)
  update
  draw_shape
  move_shape
end

def renderer
  @renderer ||= AppRender.new(self)
end

def draw_shape
  curve_tightness(organic_constant)
  fill 255
  begin_shape
  nodes.each { |vec| vec.to_curve_vertex(renderer) }
  nodes.take(NODES - 1).each { |vec| vec.to_curve_vertex(renderer) }
  end_shape(CLOSE)
end

def update
  delta = Vec2D.new(mouse_x - center.x, mouse_y - center.y)
  delta *= SPRINGING
  @accel += delta
  @center += accel
  @accel *= DAMPING
  @organic_constant = 1 - ((accel.x.abs + accel.y.abs) * 0.1)
  @node_start = create_start
end

def create_start
  (0...NODES).map do |n|
    Vec2D.new(
      center.x + DegLut.cos(n * (360 / NODES)) * radius,
      center.y + DegLut.sin(n * (360 / NODES)) * radius
    )
  end
end

def move_shape
  (0...NODES).each do |i|
    nodes[i] = Vec2D.new(
      node_start[i].x + DegLut.sin(angle[i]) * (accel.x * 2),
      node_start[i].y + DegLut.sin(angle[i]) * (accel.y * 2)
    )
    angle[i] += frequency[i]
  end
end

def settings
  size 640, 360
end
