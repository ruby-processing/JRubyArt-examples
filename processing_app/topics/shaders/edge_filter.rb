attr_reader :edges, :apply_filter

def setup
  sketch_title 'Edge Filter'
  @apply_filter = true
  @edges = load_shader(data_path('edges.glsl'))
  no_stroke
end

def draw
  background(0)
  lights
  translate(width / 2, height / 2)
  push_matrix
  rotate_x(frameCount * 0.01)
  rotate_y(frameCount * 0.01)
  box(120)
  pop_matrix
  filter(edges) if (apply_filter)

  # The sphere doesn't have the edge detection applied
  # on it because it is drawn after filter is called.
  rotate_y(frame_count * 0.02)
  translate(150, 0)
  sphere(40)
end

def mouse_pressed
  @apply_filter = !apply_filter
end

def settings
  size(640, 360, P3D)
end
