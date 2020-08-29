attr_reader :last_mouse_position, :mouse_click_state, :wrapper, :start

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title '3D Sierpinski'
  @previous_time = 0.0
  @mouse_dragged = false
  @mouse_click_state = 0.0
  # Load the shader file from the "data" folder
  @wrapper = load_shader(data_path('sierpinski.glsl'))
  # Assume the dimension of the window will not change over time
  wrapper.set('iResolution', width.to_f, height.to_f, 0.0)
  @last_mouse_position = Vec2D.new(mouse_x, mouse_y)
  @start = java.lang.System.current_time_millis
end

def draw
  puts frame_rate if (frame_count % 300).zero?
  # shader playback time (in seconds)
  current_time = (java.lang.System.current_time_millis - start) / 1000.0
  wrapper.set('iTime', current_time)
  # mouse pixel coords. xy: current (if MLB down), zw: click
  if mouse_pressed?
    @last_mouse_position = Vec2D.new(mouse_x, mouse_y)
    @mouse_click_state = 1.0
  else
    @mouse_click_state = 0.0
  end
  wrapper.set('iMouse', last_mouse_position.x, last_mouse_position.y, mouse_click_state, mouse_click_state)
  shader(wrapper)
  # Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height)
end
