# frozen_string_literal: true

# This sketch demonstrates how to play a file with Minim using an
# AudioTrigger. It's also a good example of how to draw the waveform of
# the audio. Full documentation for AudioTrigger can be found at
# http:#code.compartmental.net/minim/audioTrigger_class_audioTrigger.html
# For more information about Minim and additional features,
# visit http:#code.compartmental.net/minim/
load_library :minim
java_import 'ddf.minim.Minim'

attr_reader :minim, :kick, :snare

def settings
  size(512, 200, P2D)
end

def setup
  sketch_title 'Trigger Snare and Kick drum'
  @minim = Minim.new(self)
  # load BD.wav from the data folder
  @kick = minim.load_sample(data_path('BD.mp3'), 512)
  # An AudioSample will spawn its own audio processing Thread,
  # and since audio processing works by generating one buffer
  # of samples at a time, we can specify how big we want that
  # buffer to be in the call to load_sample.
  # above, we requested a buffer size of 512 because
  # this will make the triggering of the samples sound more responsive.
  # on some systems, this might be too small and the audio
  # will sound corrupted, in that case, you can just increase
  # the buffer size.
  # if a file doesn't exist, load_sample will return nil
  puts("Didn't get kick!") if kick.nil?
  # load SD.wav from the data folder
  @snare = minim.load_sample(data_path('SD.wav'), 512)
  puts("Didn't get snare!") if snare.nil?
end

def draw
  background(0)
  stroke(255)
  # use the mix buffer to draw the waveforms.
  (0...kick.buffer_size - 1).each do |i|
    x1 = map1d(i, 0..kick.bufferSize, 0..width)
    x2 = map1d(i + 1, 0..kick.bufferSize, 0..width)
    line(x1, 50 - kick.mix.get(i) * 50, x2, 50 - kick.mix.get(i + 1) * 50)
    line(x1, 150 - snare.mix.get(i) * 50, x2, 150 - snare.mix.get(i + 1) * 50)
  end
end

def keyPressed
  case key
  when 's'
    snare.trigger
  when 'k'
    kick.trigger
  end
end
