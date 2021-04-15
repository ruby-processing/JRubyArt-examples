

# Additive Wave
# by Daniel Shiffman.
#
# Create a more complex wave by adding two waves together.
attr_reader :dx, :amplitude, :max_waves, :y_values

def setup
  sketch_title 'Additive Wave'
  @max_waves = 4				    # Total number of waves to add together
  @wave_width = width + 16	# Width of entire wave
  @x_spacing = 8				    # How far apart should each horizontal location be spaced
  @theta = 0.0
  @amplitude = []				    # Height of wave
  @dx = []					        # Value for incrementing X, to be calculated as a function of period and x_spacing

  @max_waves.times do |i|
    amplitude << rand(10..30)
    period = rand(100..300) # How many pixels before the wave repeats
    dx << (TAU / period) * @x_spacing
  end

  frame_rate 30
  color_mode RGB, 255, 255, 255, 100
  smooth
end

def draw
  background 0
  calculate_wave
  render_wave
end

def calculate_wave
  # Increment theta (try different values for 'angular velocity' here
  @theta += 0.02

  # Set all height values to zero
  @y_values = Array.new @wave_width / @x_spacing, 0

  # Accumulate wave height values
  max_waves.times do |j|
    x = @theta
    y_values.length.times do |i|
      # Every other wave is Math.cosine instead of Math.sine
      value = j.even? ? Math.sin(x) : Math.cos(x)
      y_values[i] += value * amplitude[j]
      x += dx[j]
    end
  end
end

def render_wave
  # A simple way to draw the wave with an ellipse at each location
  no_stroke
  fill 255, 50
  ellipse_mode CENTER
  y_values.each_with_index do |y, i|
    ellipse i*@x_spacing, height / 2 + y, 16, 16
  end
end

def settings
  size 640, 360
end
