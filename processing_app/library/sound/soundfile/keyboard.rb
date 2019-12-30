# frozen_string_literal true

# This example shows how to make a simple keyboard-triggered sampler
# with the Sound library. In this sketch 5 different short samples are
# loaded and played back at different speeds, which also changes their
# perceived pitch by one or two octaves.
load_library :sound
java_import 'processing.sound.SoundFile'
NUM_SOUND = 5
attr_reader :files, :background_color

def settings
  size(640, 360)
end

def setup
  size(640, 360)
  sketch_title 'Keyboard'
  background(255)
  # Load the soundfiles from data folder
  @files = (0...NUM_SOUND).map do |i|
    SoundFile.new(self, data_path("#{i.succ}.aif"))
  end
  @background_color = [200, 200, 200]
end

def draw
  background(
    background_color[0],
    background_color[1],
    background_color[2]
  )
end

def key_pressed
  case key
  when 'a'
    files[0].play(0.5, 1.0)
  when 's'
    files[1].play(0.5, 1.0)
  when 'd'
    files[2].play(0.5, 1.0)
  when 'f'
    files[3].play(0.5, 1.0)
  when 'g'
    files[4].play(0.5, 1.0)
  when 'h'
    files[0].play(1.0, 1.0)
  when 'j'
    files[1].play(1.0, 1.0)
  when 'k'
    files[2].play(1.0, 1.0)
  when 'l'
    files[3].play(1.0, 1.0)
  when ''
    files[4].play(1.0, 1.0)
  when '\''
    files[0].play(2.0, 1.0)
  when 'q'
    files[1].play(2.0, 1.0)
  when 'w'
    files[2].play(2.0, 1.0)
  when 'e'
    files[3].play(2.0, 1.0)
  when 'r'
    files[4].play(2.0, 1.0)
  when 't'
    files[0].play(3.0, 1.0)
  when 'y'
    files[1].play(3.0, 1.0)
  when 'u'
    files[2].play(3.0, 1.0)
  when 'i'
    files[3].play(3.0, 1.0)
  when 'o'
    files[4].play(3.0, 1.0)
  when 'p'
    files[0].play(4.0, 1.0)
  when '['
    files[1].play(4.0, 1.0)
    # no valid key was pressed, store that information
  else
    @background_color = (0..3).map { rand(255) }
  end
end
