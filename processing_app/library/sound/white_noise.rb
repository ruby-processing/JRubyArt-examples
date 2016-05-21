# This is a simple white noise generator. It can be started with .play(amp).
# In this example it is started and stopped by clicking into the renderer window.
load_library :sound

include_package 'processing.sound'

attr_reader :amp, :noise

def settings
  size(640, 360)
end

def setup
  sketch_title 'White Noise'
  background(255)
  @amp = 0.0
  # Create the noise generator
  @noise = WhiteNoise.new(self)
  noise.play(amp)
end      

def draw
  # Map mouseX from 0.0 to 1.0 for amplitude
  noise.amp(map1d(mouse_x, (width..0), (0.0..1.0))) # reversed for fun
  # Map mouseY from -1.0 to 1.0 for left to right
  noise.pan(map1d(mouse_y, (0..height), (-1.0..1.0)))
end
