# This sketch shows how to use the FFT class to analyze a stream
# of sound. Change the variable bands to get more or less
# spectral bands to work with. Smooth_factor determines how
# much the signal will be smoothed on a scale form 0-1.

load_library :sound

include_package 'processing.sound'

# Declare the processing sound variables
attr_reader :fft, :r_width, :sum
# Declare a scaling factor
SCALE = 5
# Define how many FFT bands we want
BANDS = 128
# Create a smoothing factor
SMOOTH_FACTOR = 0.2

def settings
  size(640, 360)
end

def setup
  sketch_title 'FFT Spectrum'
  background(255)
  @sum = Array.new(BANDS, 0)
  # Calculate the width of the rects depending on how many bands we have
  @r_width = width.to_f/BANDS

  #Load and play a soundfile and loop it. This has to be called
  # before the FFT is created.
  sample = SoundFile.new(self, data_path('beat.aiff'))
  sample.loop

  # Create and patch the FFT analyzer
  @fft = FFT.new(self, BANDS)
  fft.input(sample)
end

def draw
  # Set background color, noStroke and fill color
  background(125,255,125)
  fill(255,0,150)
  no_stroke
  fft.analyze
  fft.spectrum.each_with_index do |spectrum, i|
    # smooth the FFT data by smoothing factor
    sum[i] += (spectrum - sum[i]) * SMOOTH_FACTOR
    # draw the rects with a scale factor
    rect( i * r_width, height, r_width, -sum[i] * height * SCALE )
  end
end
