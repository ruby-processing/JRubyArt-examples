# frozen_string_literal: true

java_import 'ddf.minim.ugens.Instrument'
# class Tick can access app variables by including Processing::App module
# But we must use instance variable to set the beat
class Tick
  include Instrument
  include Processing::Proxy

  def noteOn(_dur)
    hat.trigger if hatRow[beat]
    snare.trigger if snrRow[beat]
    kick.trigger if kikRow[beat]
  end

  def noteOff
    # next beat
    Processing.app.beat = (beat + 1) % 16
    # set the new tempo
    out.setTempo(bpm)
    # play this again right now, with a sixteenth note duration
    out.playNote(0, 0.25, self)
  end
end
