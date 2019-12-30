# frozen_string_literal: true

# Grab audio from the microphone input and draw a circle whose size
# is determined by how loud the audio input is.
load_library :sound

java_import 'processing.sound.AudioIn'
java_import 'processing.sound.Amplitude'

attr_reader :input, :loudness

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Audio Input'
  # Create an Audio input and grab the 1st channel
  @input = AudioIn.new(self, 0)
  # Begin capturing the audio input
  input.start
  # start activates audio capture so that you can use it as
  # the input to live sound analysis, but it does NOT cause the
  # captured audio to be played back to you. if you also want the
  # microphone input to be played back to you, call input.play
  # instead (be careful with your speaker volume, you might produce
  # painful audio feedback. best to first try it out wearing
  # headphones!) Create a new Amplitude analyzer
  @loudness = Amplitude.new(self)
  # Patch the input to the volume analyzer
  loudness.input(input)
end

def draw
  # Adjust the volume of the audio input based on mouse position
  inputLevel = map1d(mouseY, 0..height, 1.0..0.0)
  input.amp(inputLevel)
  # loudness.analyze return a value between 0 and 1. To adjust
  # the scaling and mapping of an ellipse we scale from 0 to 0.5
  volume = loudness.analyze
  size = map1d(volume, 0..0.5, 1..350)
  background(125, 255, 125)
  no_stroke
  fill(255, 0, 150)
  # We draw a circle whose size is coupled to the audio analysis
  ellipse(width / 2, height / 2, size, size)
end
