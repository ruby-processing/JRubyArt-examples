# frozen_string_literal: true

# This is a pulse-wave oscillator. On top of the sound frequency, which
# you can also set for all other oscillators, the pulse wave also allows
# you to adjust the pulse's relative width, using the .width method.
# If you want to set all oscillator parameters at the same time you can
# use .set(freq, width, amp, add, pan)
load_library :sound
java_import 'processing.sound.Pulse'

attr_reader :pulse

def settings
  size(640, 360)
end

def setup
  sketch_title 'Pulse Width'
  background(255)
  # Create and start the pulse wave oscillator
  @pulse = Pulse.new(self)
  # pulse waves can appear loud to the human ear, so cut volume
  pulse.amp(0.4)
  pulse.play
end

def draw
  # Map mouseX from 20Hz to 500Hz for frequency
  frequency = map1d(mouseX, 0..width, 20.0..500.0)
  pulse.freq(frequency)
  # Map mouseY from 0.0 to 1.0 for the relative width of the pulse.
  pulse_width = map1d(mouseY, 0..height, 0.0..1.0)
  pulse.width(pulse_width)
end
