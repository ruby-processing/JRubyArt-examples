# from shadertoy example by Edan Kwan
# https://www.shadertoy.com/view/3sySRK

attr_reader :previous_time, :wrapper, :start

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title 'Metaballs Two'
  @previous_time = 0.0
  @wrapper = load_shader(data_path('metaballs_two.glsl'))
  # Assume the dimension of the window will not change over time
  wrapper.set('iResolution', width.to_f, height.to_f, 0.0)
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
  # Apply the specified shader to any geometry drawn from this point
  shader(wrapper)
  # Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height)
end
