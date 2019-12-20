# frozen_string_literal: true

# This sketch demonstrates how to create synthesized sound with Minim
# using an AudioOutput and an Instrument we define. By using the
# playNote method you can schedule notes to played at some point in the
# future, essentially allowing to you create musical scores with code.
# Because they are constructed with code, they can be either
# deterministic or different every time. This sketch creates a
# deterministic score, meaning it is the same every time you run the
# sketch. For more complex examples of using playNote check out
# algorithmicCompExample and compositionExample. For more information
# about Minim and additional features, visit
# http://code.compartmental.net/minim/

load_libraries :minim, :sine_instrument
java_import 'ddf.minim.Minim'

attr_reader :out

def settings
  size(512, 200, P2D)
end

def setup
  sketch_title 'Create Instrument'
  minim = Minim.new(self)
  @out = minim.getLineOut
  # when providing an Instrument, we always specify start time and duration
  out.playNote(0.0, 0.9, SineInstrument.new(out, 97.99))
  out.playNote(1.0, 0.9, SineInstrument.new(out, 123.47))
  # we can use the Frequency class to create frequencies from pitch names
  out.playNote(2.0, 2.9, SineInstrument.new(out, Frequency.ofPitch('C3').asHz))
  out.playNote(3.0, 1.9, SineInstrument.new(out, Frequency.ofPitch('E3').asHz))
  out.playNote(4.0, 0.9, SineInstrument.new(out, Frequency.ofPitch('G3').asHz))
end

def draw
  background(0)
  stroke(255)
  # draw the waveforms
  (out.bufferSize - 1).times do |i|
    line(i, 50 + out.left.get(i) * 50, i + 1, 50 + out.left.get(i + 1) * 50)
    line(i, 150 + out.right.get(i) * 50, i + 1, 150 + out.right.get(i + 1) * 50)
  end
end
