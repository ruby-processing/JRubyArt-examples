# This example shows how to create a cluster of sine oscillators, change the
# frequency and detune them depending on the position of the mouse in the
# renderer window. The Y position determines the basic frequency of the
# oscillator and X the detuning of the oscillator. The basic frequncy ranges
# between 150 and 1150 Hz

load_library :sound

include_package 'processing.sound'

# The number of oscillators
NUM_SINES = 5

# A for calculating the amplitudes
attr_reader :sine_volume, :sine_waves

def setup
  sketch_title 'Sine Cluster'
  background 255
  no_stroke
  create_oscillators
end

def create_oscillators
  # Create the oscillators and amplitudes
  @sine_waves = []
  @sine_volume = []
  NUM_SINES.times do |i|
    # The overall amplitude shouldn't exceed 1.0
    # The ascending waves will get lower in volume the higher the frequency
    sine_volume << (1.0 / NUM_SINES) / (i + 1)
    # Create the Sine Oscillators and start them
    wav = SinOsc.new(self)
    wav.play
    sine_waves << wav
  end
end

def draw
  fill mouse_x, mouse_y, 0, 100
  ellipse(mouse_x, mouse_y, 10, 10)
  # Use mouse_y to get values from 0.0 to 1.0
  yoffset = (height - mouse_y) / height.to_f
  # Set that value logarithmically to 150 - 1150 Hz
  frequency = 1000**yoffset + 150
  # Use mouse_x from -0.5 to 0.5 to get a multiplier for detuning the
  # oscillators
  detune = mouse_x.to_f / width - 0.5
  # Set the frequencies, detuning and volume
  sine_waves.each_with_index do |wav, i|
    wav.freq(frequency * (i + 1 + i * detune))
    wav.amp(sine_volume[i])
  end
end

def settings
  size 500, 500, P2D
end

