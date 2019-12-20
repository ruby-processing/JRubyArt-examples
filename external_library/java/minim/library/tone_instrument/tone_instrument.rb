# frozen_string_literal: true

# java_import 'ddf.minim.Minim'

%w[ADSR Instrument Oscil Waves].each do |klass|
  java_import "ddf.minim.ugens.#{klass}"
end

# Every instrument must implement the Instrument interface so
# playNote can call the instrument's methods.
class ToneInstrument
  include Instrument
  attr_reader :adsr, :out

  # constructor for this instrument NB: includes line_out
  def initialize(out, frequency, amplitude)
    # create new instances of any UGen objects as necessary
    sineOsc = Oscil.new(frequency, amplitude, Waves::TRIANGLE)
    @adsr = ADSR.new(0.5, 0.01, 0.05, 0.5, 0.5)
    @out = out
    # patch everything together up to the final output
    sineOsc.patch(adsr)
  end

  # every instrument must have a noteOn method
  def noteOn(dur)
    # turn on the ADSR
    adsr.noteOn
    # patch to the output
    adsr.patch(out)
   end

  # every instrument must have a noteOff method
  def noteOff
    # tell the ADSR to unpatch after the release is finished
    adsr.unpatchAfterRelease(out)
    # call the noteOff
    adsr.noteOff
  end
end
