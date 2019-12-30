# frozen_string_literal: true

# This example shows how to create a cluster of sine oscillators, change
# the frequency and detune them relative to each other depending on the
# position of the mouse in the renderer window. The Y position
# determines the basic frequency of the oscillators, the X position
# their detuning. The basic frequncy ranges between 150 and 1150 Hz.
load_library :sound
java_import 'processing.sound.SinOsc'

DIM = 5
attr_reader :sine_waves, :sine_volumes

def settings
  size(500, 500)
end

def setup
  sketch_title 'Sine Cluster'
  background(255)
  # Create the oscillators and amplitudes
  @sine_waves = (0..DIM).map { SinOsc.new(self) }
  @sine_volumes = (0..DIM).map { |i| (1.0 / DIM) / (i + 1) }
  sine_waves.each(&:play)
end

def draw
  no_stroke
  yoffset = (height - mouseY) / height.to_f
  frequency = 1000**yoffset + 150
  detune = mouseX / width.to_f - 0.5
  sine_waves.each_with_index do |wav, i|
    wav.freq(frequency * (i + 1 + i * detune))
    wav.amp(sine_volumes[i])
  end
end
