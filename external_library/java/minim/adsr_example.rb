# frozen_string_literal: true

# ADSRExample is an example of using the ADSR envelope within an instrument.
# For more information about Minim and additional features,
# visit http://code.compartmental.net/minim/
# author: Anderson Mills<br/>
# Anderson Mills's work was supported by numediart (www.numediart.org)

load_libraries :minim, :tone_instrument
java_import 'ddf.minim.Minim'

attr_reader :out

def setup
  sketch_title 'ADSR Example'
  minim = Minim.new(self)
  @out = minim.get_line_out(Minim::MONO, 2048)
  # pause time when adding a bunch of notes at once
  out.pause_notes
  # make four repetitions of the same pattern
  4.times do |i|
    # add some low notes
    out.play_note(1.25 + i * 2.0, 0.3, ToneInstrument.new(out, 75, 0.49))
    out.play_note(2.50 + i * 2.0, 0.3, ToneInstrument.new(out, 75, 0.49))

    # add some middle notes
    out.play_note(1.75 + i * 2.0, 0.3, ToneInstrument.new(out, 175, 0.4))
    out.play_note(2.75 + i * 2.0, 0.3, ToneInstrument.new(out, 175, 0.4))

    # add some high notes
    out.play_note(1.25 + i * 2.0, 0.3, ToneInstrument.new(out, 3750, 0.07))
    out.play_note(1.5 + i * 2.0, 0.3, ToneInstrument.new(out, 1750, 0.02))
    out.play_note(1.75 + i * 2.0, 0.3, ToneInstrument.new(out, 3750, 0.07))
    out.play_note(2.0 + i * 2.0, 0.3, ToneInstrument.new(out, 1750, 0.02))
    out.play_note(2.25 + i * 2.0, 0.3, ToneInstrument.new(out, 3750, 0.07))
    out.play_note(2.5 + i * 2.0, 0.3, ToneInstrument.new(out, 5550, 0.09))
    out.play_note(2.75 + i * 2.0, 0.3, ToneInstrument.new(out, 3750, 0.07))
  end
  # resume time after a bunch of notes are added at once
  out.resumeNotes
end

# draw is run many times
def draw
  # erase the window to black
  background(0)
  # draw using a white stroke
  stroke(255)
  # draw the waveforms
  (0...(out.bufferSize - 1)).each do |i|
    # find the x position of each buffer value
    x1  =  map1d(i, 0..out.bufferSize, 0..width)
    x2  =  map1d(i + 1, 0..out.bufferSize, 0..width)
    # draw a line from one buffer position to the next for both channels
    line(x1, 50 + out.left.get(i) * 50, x2, 50 + out.left.get(i + 1) * 50)
    line(x1, 150 + out.right.get(i) * 50, x2, 150 + out.right.get(i + 1) * 50)
  end
end

def settings
  size(512, 200, P2D)
end
