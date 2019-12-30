# frozen_string_literal: true

# Play a sound sample and pass it through a tape source, changing the source
# parameters based on the mouse position.
load_library :sound
java_import 'processing.sound.WhiteNoise'
java_import 'processing.sound.BandPass'

attr_reader :filter, :source

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Band Pass Filter'
  # Create the noise generator + filter
  @filter = BandPass.new(self)
  @source = WhiteNoise.new(self)
  # Connect the filter to the source unit
  source.play
  filter.process(source)
end

def draw
  # Map the left/right mouse position to a cutoff frequency between 20 and 10000 Hz
  frequency = map1d(mouseX, 0..width, 20..10_000)
  # And the vertical mouse position to the width of the band to be passed through
  bandwidth = map1d(mouseY, 0..height, 1_000..100)
  filter.freq(frequency)
  filter.bw(bandwidth)
  # Draw a circle indicating the position + width of the frequency window
  # that is allowed to pass through
  background(125, 255, 125)
  no_stroke
  fill(255, 0, 150)
end
