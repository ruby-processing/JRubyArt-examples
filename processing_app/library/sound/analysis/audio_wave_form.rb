# frozen_string_literal: true

# Play a sound sample and pass it through a tape delay, changing the delay
# parameters based on the mouse position.

load_library :sound
java_import 'processing.sound.Waveform'
java_import 'processing.sound.SoundFile'

attr_reader :waveform, :sample
SAMPLES = 100
def settings
  size(640, 360)
end

def setup
  sketch_title 'Waveform Analyser'
  # Load and play a soundfile and loop it
  @sample = SoundFile.new(self, data_path('beat.aiff'))
  sample.loop
  # Create and patch the waveform tracker
  @waveform = Waveform.new(self, SAMPLES)
  waveform.input(sample)
end

def draw
  # Set background color, noFill and stroke style
  background(0)
  stroke(255)
  strokeWeight(2)
  noFill

  # Perform the analysis
  waveform.analyze

  begin_shape
  SAMPLES.times do |i|
    # Draw current data of the waveform
    # Each sample in the data array is between -1 and +1
    vertex(
      map1d(i, 0..SAMPLES, 0..width),
      map1d(waveform.data[i], -1..1, 0..height)
    )
  end
  end_shape
end
