# frozen_string_literal: true

# Play a sound sample and pass it through a tape delay, changing the delay
# parameters based on the mouse position.
load_library :sound
java_import 'processing.sound.Amplitude'
java_import 'processing.sound.SoundFile'

attr_reader :rms, :sample, :sum
SMOOTHING_FACTOR = 0.25
def settings
  size(640, 360)
end

def setup
  sketch_title 'Peak Amplitude'
  # Load and play a soundfile and loop it
  @sample = SoundFile.new(self, data_path('beat.aiff'))
  sample.loop
  # Create and patch the rms tracker
  @rms = Amplitude.new(self)
  rms.input(sample)
  @sum = 0
end

def draw
  # Set background color, noStroke and fill color
  background(125, 255, 125)
  noStroke
  fill(255, 0, 150)

  # smooth the rms data by smoothing factor
  @sum += (rms.analyze - sum) * SMOOTHING_FACTOR

  # rms.analyze() return a value between 0 and 1. Its
  # scaled to height/2 and then multiplied by a fixed scale factor
  rms_scaled = sum * (height / 2) * 5

  # We draw a circle whose size is coupled to the audio analysis
  ellipse(width / 2, height / 2, rms_scaled, rms_scaled)
end
