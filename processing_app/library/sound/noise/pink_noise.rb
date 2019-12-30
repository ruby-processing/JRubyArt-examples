# frozen_string_literal: true

# Inspect the frequency spectrum of different simple oscillators.
load_library :sound
java_import 'processing.sound.PinkNoise'

attr_reader :noise

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Pink Noise'
  # Create and start the noise generator
  @noise = PinkNoise.new(self)
  noise.play
end

def draw
  # Map mouseX from -1.0 to 1.0 for left to right
  noise.pan(map1d(mouseX, 0..width, -1.0..1.0))
  # Map mouseY from 0.0 to 0.3 for amplitude
  # (the higher the mouse position, the louder the sound)
  noise.amp(map1d(mouseY, 0..height, 0.3..0.0))
end
