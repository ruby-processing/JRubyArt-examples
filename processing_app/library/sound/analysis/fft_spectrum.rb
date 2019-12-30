# frozen_string_literal: true

# Play a sound sample and pass it through a tape delay, changing the delay
# parameters based on the mouse position.
load_library :sound
java_import 'processing.sound.FFT'
java_import 'processing.sound.SoundFile'

attr_reader :fft, :sample, :sum, :bar_width
SMOOTHING_FACTOR = 0.25
BANDS = 128
SCALE = 5
def settings
  size(640, 360)
end

def setup
  sketch_title 'FFT Spectrum'
  @bar_width = width / BANDS.to_f
  # Load and play a soundfile and loop it
  @sample = SoundFile.new(self, data_path('beat.aiff'))
  sample.loop
  # Create and patch the fft tracker
  @fft = FFT.new(self)
  fft.input(sample)
  @sum = Array.new(BANDS, 0.0)
end

def draw
  # Set background color, noStroke and fill color
  background(125, 255, 125)
  noStroke
  fill(255, 0, 150)
  fft.analyze
  BANDS.times do |i|
    # Smooth the FFT spectrum data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * SMOOTHING_FACTOR
    rect(i * bar_width, height, bar_width, -sum[i] * height * SCALE)
  end
end
