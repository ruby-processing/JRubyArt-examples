# frozen_string_literal: true

# This sketch demonstrates how to play a file with Minim using an
# AudioPlayer. It's also a good example of how to draw the waveform of
# the audio. Full documentation for AudioPlayer can be found at
# http://code.compartmental.net/minim/audioplayer_class_audioplayer.html
# For more information about Minim and additional features,
# visit http://code.compartmental.net/minim/
load_library :minim
java_import 'ddf.minim.Minim'

PLAYING = 'Press any key to pause playback.'
NOT = 'Press any key to start playback.'
attr_reader :player

def settings
  size(512, 200, P2D)
end

def setup
  sketch_title 'Playing A File'
  minim = Minim.new(self)
  @player = minim.load_file(data_path('groove.mp3'))
end

def draw
  background(0)
  stroke(255)
  (0...player.buffer_size - 1).each do |i|
    x1 = map1d(i, 0..player.bufferSize, 0..width)
    x2 = map1d(i + 1, 0..player.bufferSize, 0..width)
    line(
      x1,
      50 + player.left.get(i) * 50,
      x2,
      50 + player.left.get(i + 1) * 50
    )
    line(
      x1,
      150 + player.right.get(i) * 50,
      x2,
      150 + player.right.get(i + 1) * 50
    )
  end
  # draws a vertical line where playback is up to
  posx = map1d(player.position, 0..player.length, 0..width)
  stroke(0, 200, 0)
  line(posx, 0, posx, height)
  message = player.playing? ? PLAYING : NOT
  text(message, 10, 20)
end

def key_pressed
  if player.playing?
    player.pause
    # if finished, rewind and call play again
  elsif player.position == player.length
    player.rewind
    player.play
  else
    player.play
  end
end
