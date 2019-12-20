# frozen_string_literal: true

%w[Frequency Instrument Line Oscil Waves].each do |klass|
  java_import "ddf.minim.ugens.#{klass}"
end

# to make an Instrument we must define a class
# that includes Instrument interface (as a module).
class SineInstrument
  include Instrument

  attr_reader :wave, :amp_env, :out, :tone_instrument

  def initialize(out, frequency)
    # make a sine wave oscillator
    # the amplitude is zero because
    # we are going to patch a Line to it anyway
    @out = out
    @wave = Oscil.new(frequency, 0, Waves::SINE)
    @amp_env = Line.new
    amp_env.patch(wave.amplitude)
  end

  # this is called by the sequencer when this instrument
  # should start making sound. the duration is expressed in seconds.
  def noteOn(duration)
    # start the amplitude envelope
    amp_env.activate(duration, 0.5, 0)
    # attach the oscil to the output so it makes sound
    wave.patch(out)
  end

  # this is called by the sequencer when the instrument should
  # stop making sound
  def noteOff
    wave.unpatch(out)
  end
end
