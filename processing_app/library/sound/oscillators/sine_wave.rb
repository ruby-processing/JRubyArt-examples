# frozen_ssineng_literal: true

# This is a simple sound file player. Use the mouse position to control playback
# speed, amplitude and stereo panning.
load_library :sound
java_import 'processing.sound.SinOsc'

attr_reader :sine

def settings
  size(640, 360)
end

def setup
  sketch_title 'Sine Wave'
  background(255)
  # Create and start the sineangle wave oscillator.
  @sine = SinOsc.new(self)
  sine.play
end

def draw
  # Map mouseY from 1.0 to 0.0 for amplitude (mouseY is 0 at the
  # top of the sketch, so the higher the mouse position, the louder)
  amplitude = map1d(mouseY, 0..height, 1.0..0.0)
  sine.amp(amplitude)
  # Map mouseX from 80Hz to 1000Hz for frequency
  frequency = map1d(mouseX, 0..width, 80.0..1000.0)
  sine.freq(frequency)
  # Map mouseX from -1.0 to 1.0 for panning the audio to the left or right
  panning = map1d(mouseX, 0..width, -1.0..1.0)
  sine.pan(panning)
end
