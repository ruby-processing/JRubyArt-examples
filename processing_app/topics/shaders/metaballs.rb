attr_reader :last_mouse_position, :mouse_click_state, :mouse_dragged, :shader_t
attr_reader :start

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title 'Shadertoy Metaballs'
  @previous_time = 0.0
  @mouse_dragged = false
  @mouse_click_state = 0.0
  # Load the shader file from the "data" folder
  @shader_t = load_shader(data_path('metaballs.glsl'))
  # Assume the dimension of the window will not change over time
  shader_t.set('iResolution', width.to_f, height.to_f, 0.0)
  @last_mouse_position = Vec2D.new(mouse_x, mouse_y)
  @start = java.lang.System.current_time_millis
end

def draw
  # shader playback time (in seconds)
  current_time = (java.lang.System.current_time_millis - start) / 1000.0
  shader_t.set('iTime', current_time)
  if mouse_pressed?
    @last_mouse_position = Vec2D.new(mouse_x, mouse_y)
    @mouse_click_state = 1.0
  else
    @mouse_click_state = 0.0
  end
  shader_t.set('iMouse', last_mouse_position.x, last_mouse_position.y, mouse_click_state, mouse_click_state)
  # Apply the specified shader to any geometry drawn from this point
  shader(shader_t)
  # Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height)
end
