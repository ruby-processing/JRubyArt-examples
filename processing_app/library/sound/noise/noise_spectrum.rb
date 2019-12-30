# frozen_string_literal: true

# Inspect the frequency spectrum of different simple noises.
load_library :sound
PRE = %w[White Pink Brown].freeze
PRE.each do |pre|
  java_import "processing.sound.#{pre}Noise"
end
java_import 'processing.sound.FFT'

attr_reader :current, :fft, :noises
FFT_BANDS = 512

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Noise Spectrum'
  @current = 0
  # Create the noises
  @noises = PRE.map { |pre| eval("#{pre}Noise.new(self)") }
  noises[current].play
  @fft = FFT.new(self, FFT_BANDS)
  fft.input(noises[current])
end

def draw
  # Only play one of the four noises, based on mouseY
  next_noise = constrain(
    map1d(mouseY, 0..height, 0..noises.length),
    0,
    noises.length - 1
  )
  unless next_noise == current
    noises[current].stop
    @current = next_noise
    noises[current].play
    # Switch FFT analysis over to the newly selected oscillator.
    fft.input(noises[current])
    # Play
  end
  # Draw frequency spectrum.
  background(125, 255, 125)
  fill(255, 0, 150)
  no_stroke
  fft.analyze
  r_width = width / FFT_BANDS.to_f
  FFT_BANDS.times do |i|
    rect(i * r_width, height, r_width, -fft.spectrum[i] * height)
  end
  # Display the name of the oscillator class.
  textSize(32)
  fill(0)
  vertical_position = map1d(current, 0..noises.length, 32..height)
  osc_name = noises[current].get_class.get_simple_name
  text(osc_name, 0, vertical_position)
end
