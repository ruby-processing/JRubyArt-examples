# This example shows how to create a cluster of sine oscillators, change the
# frequency and detune them depending on the position of the mouse in the
# renderer window. The Y position determines the basic frequency of the
# oscillator and X the detuning of the oscillator. The basic frequncy ranges
# between 150 and 1150 Hz
load_library :sound

java_import 'processing.sound.SinOsc'

# The number of oscillators
NUM_SINES = 5

# A for calculating the amplitudes
attr_reader :sine_volume, :sine_waves

# re-open SinOsc class to deal with java signatures see
# https://github.com/jruby/jruby/wiki/ImprovingJavaIntegrationPerformance
# for explanation on why to use java_alias (over java_send)
class SinOsc
  java_alias :just_play, :play
  java_alias :freq_float, :freq, [Java::float]
  java_alias :amp_float, :amp, [Java::float]
end

def setup
  sketch_title 'Sine Cluster'
  background 255
  no_stroke
  # here we use tap so we can return a SinOsc object after calling :just_play
  @sine_waves = (0..NUM_SINES).map { SinOsc.new(self).tap(&:just_play) }
  @sine_volume = (0..NUM_SINES).map { |i| (1.0 / NUM_SINES) / (i + 1) }
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
  sine_waves.each_with_index do |wav, idx|
    wav.freq_float(frequency * (idx + 1 + idx * detune))
    wav.amp_float(sine_volume[idx])
  end
end

def settings
  size 500, 500, P2D
end
