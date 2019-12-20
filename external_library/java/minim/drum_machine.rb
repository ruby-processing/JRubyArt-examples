# frozen_string_literal: true

# This sketch is a more involved use of AudioSamples to create a simple drum machine.
# Click on the buttons to toggle them on and off. The buttons that are on will trigger
# samples when the beat marker passes over their column. You can change the tempo by
# clicking in the BPM box and dragging the mouse up and down.
# We achieve the timing by using AudioOutput's playNote method and a cleverly written Instrument.
# For more information about Minim and additional features,
# visit http://code.compartmental.net/minim/

load_libraries :minim, :tick
java_import 'ddf.minim.Minim'
java_import 'ddf.minim.ugens.Sampler'
attr_reader :minim, :out, :kick, :snare, :hat, :bpm, :buttons
attr_reader :kikRow, :snrRow, :hatRow
attr_accessor :beat
def setup
  sketch_title 'Drum Machine'
  minim = Minim.new(self)
  @out   = minim.getLineOut
  @hatRow = Array.new(16, false)
  @snrRow = Array.new(16, false)
  @kikRow = Array.new(16, false)
  @buttons = []
  @bpm = 120
  @beat = 0
  # load all of our samples, using 4 voices for each.
  # this will help ensure we have enough voices to handle even
  # very fast tempos.
  @kick = Sampler.new(data_path('BD.wav'), 4, minim)
  @snare = Sampler.new(data_path('SD.wav'), 4, minim)
  @hat   = Sampler.new(data_path('CHH.wav'), 4, minim)
  # patch samplers to the output
  kick.patch(out)
  snare.patch(out)
  hat.patch(out)
  16.times do |i|
    buttons << Rect.new(10 + i * 24, 50, hatRow, i)
    buttons << Rect.new(10 + i * 24, 100, snrRow, i)
    buttons << Rect.new(10 + i * 24, 150, kikRow, i)
  end
  # start the sequencer
  out.setTempo(bpm)
  out.playNote(0, 0.25, Tick.new)
end

def draw
  background(0)
  fill(255)
  # text(frameRate, width - 60, 20)
  buttons.each(&:draw)
  stroke(128)
  (beat % 4).zero? ? fill(200, 0, 0) : fill(0, 200, 0)
  # beat marker
  rect(10 + beat * 24, 35, 14, 9)
end

def mouse_pressed
  buttons.each(&:mouse_pressed)
end

def settings
  size(395, 200)
end
