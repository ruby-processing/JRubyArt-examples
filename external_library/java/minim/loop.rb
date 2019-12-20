# frozen_string_literal: true

# This sketch demonstrates how to use the loop method of a Playable class.
# The class used here is AudioPlayer, but you can also loop an AudioSnippet.
# When you call loop() it will make the Playable playback in an infinite loop.
# If you want to make it stop looping you can call play() and it will finish the
# current loop and then stop. Press 'l' to start the player looping.

load_library :minim
java_import 'ddf.minim.Minim'

attr_reader :groove

def settings
  size(512, 200, P2D)
end

def setup
  sketch_title "Press \'l\' key to loop"
  minim = Minim.new(self)
  @groove = minim.load_file(data_path('groove.mp3'), 2048)
end

def draw
  background(0)
  stroke(255)
  (0...groove.buffer_size - 1).each do |i|
    line(i, 50 + groove.left.get(i) * 50, i + 1, 50 + groove.left.get(i + 1) * 50)
    line(i, 150 + groove.right.get(i) * 50, i + 1, 150 + groove.right.get(i + 1) * 50)
  end
end

def key_pressed
  return unless key == 'l'

  groove.loop
end
