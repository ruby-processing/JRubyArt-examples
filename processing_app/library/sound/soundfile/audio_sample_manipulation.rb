# frozen_string_literal: true

# Allocate a new audio sample and manually fill it with a sine wave that
# gets scrambled every time the mouse is pressed. As the order of data
# pos is scrambled more and more, the original sine wave signal becomes
# less and less audible until it is completely washed out by noise
# artefacts.
load_library :sound
java_import 'processing.sound.AudioSample'

attr_reader :sample

def settings
  size(640, 360)
end

def setup
  sketch_title 'AudioSample Demo'
  background(255)
  # Create an array of sine wave oscillations.
  resolution = 1_000
  sinewave = (0..resolution).map { |i| sin(TWO_PI * i / resolution) }
  # Set framerate to play 200 oscillations/second
  @sample = AudioSample.new(
    self,
    sinewave.to_java(:float),
    500 * resolution
  )
  # Play the sample in a loop (but don't make it too loud)
  sample.amp(0.3)
  sample.loop
end

def draw; end

def mouse_pressed
  # Every time the mouse is pressed, swap two of the sample frames around.
  i = rand(0..sample.frames)
  j = rand(0..sample.frames)

  # Read a frame each from their respective positions
  onevalue = sample.read(i)
  othervalue = sample.read(j)
  # and write them back the other way around
  sample.write(i, othervalue)
  sample.write(j, onevalue)
end
