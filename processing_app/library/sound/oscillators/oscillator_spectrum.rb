# frozen_string_literal: true

# Inspect the frequency spectrum of different simple oscillators.
load_library :sound

PRE = %w[Saw Sin Tri Sqr].freeze
PRE.each do |pre|
  java_import "processing.sound.#{pre}Osc"
end
java_import 'processing.sound.Pulse'
java_import 'processing.sound.FFT'

attr_reader :count, :current, :fft, :oscillators

FFT_BANDS = 512

def settings
  size(640, 360)
end

def setup
  sketch_title 'Pulse Width'
  background(255)
  @current = 0
  # Create the oscillators
  @oscillators = PRE.map { |pre| eval("#{pre}Osc.new(self)") }
  # Special treatment for the Pulse oscillator to set its pulse width.
  pulse = Pulse.new(self)
  pulse.width(0.05)
  oscillators << pulse
  @count = oscillators.length
  # Initialise the FFT and start playing the (default) oscillator.
  @fft = FFT.new(self, FFT_BANDS)
  oscillators[current].play
end

def draw
  # Only play one of the four oscillators, based on mouseY
  next_oscillator = constrained_map(mouseY, 0..height, 0..count)
  unless next_oscillator == current
    oscillators[current].stop
    @current = next_oscillator
    # Switch FFT analysis over to the newly selected oscillator.
    fft.input(oscillators[current])
    # Play
    oscillators[current].play
  end
  # Map mouseX from 20Hz to 22000Hz for frequency.
  frequency = map1d(mouseX, 0..width, 20.0..22_000.0)
  # Update oscillator frequency.
  oscillators[current].freq(frequency)
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
  vertical_position = map1d(current, 0..count, 32..height)
  osc_name = oscillators[current].get_class.get_simple_name
  text(osc_name, 0, vertical_position)
end
