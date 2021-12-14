attr_reader :previous_time, :wrapper, :start
# Shader by Victor Shepardson

def settings
  size(800, 450, P2D)
end

def setup
  sketch_title 'Sigmoids n sine (by Victor Shepardson)'
  @previous_time = 0.0
  @mouse_dragged = false
  @mouse_click_state = 0.0
  @wrapper = load_shader(data_path('sigmoids.glsl'))
  # Assume the dimension of the window will not change over time
  wrapper.set('iResolution', width.to_f, height.to_f, 0.0)
  @last_mouse_position = Vec2D.new(mouse_x, mouse_y)
  @start = java.lang.System.current_time_millis
end

def playback_time_seconds
  (java.lang.System.current_time_millis - start) / 1000.0
end

def render_time
  playback_time_seconds - previous_time
end

def draw
  wrapper.set('iTime', playback_time_seconds)
  @previous_time = playback_time_seconds
  shader(wrapper)
  # Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height)
end
