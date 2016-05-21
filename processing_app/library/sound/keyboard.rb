# This example shows how to make a simple sampler and sequencer with the Sound
# library. In this sketch 5 different short samples are loaded and played back
# at different pitches, in this when 5 different octaves. The sequencer
# triggers and event every 200-1000 mSecs randomly. Each time a sound is
# played a colored rect with a random color is displayed.
load_library :sound

include_package 'processing.sound'

# Define the number of samples
NUM_SOUNDS = 5
attr_reader :device, :file, :value

def setup
  sketch_title 'Keyboard'
  background(255)
  # Create a Sound renderer and an array of empty soundfiles
  @device = AudioDevice.new(self, 48_000, 32)
  @file = []
  @value = Array.new(3, 0)
  # Load 5 soundfiles from a folder in a for loop. By naming the files 1., 2.,
  # 3., n.aif it is easy to iterate through the folder and load all files in
  # one line of code.
  NUM_SOUNDS.times do |i|
    file << SoundFile.new(self, format('%d.aif', (i + 1)))
  end
end

def draw
  background(*value) # splat array values
end

def key_pressed
  defined = true
  case key
  when 'a'
    file[0].play(0.5, 1.0)
  when 's'
    file[1].play(0.5, 1.0)
  when 'd'
    file[2].play(0.5, 1.0)
  when 'f'
    file[3].play(0.5, 1.0)
  when 'g'
    file[4].play(0.5, 1.0)
  when 'h'
    file[0].play(1.0, 1.0)
  when 'j'
    file[1].play(1.0, 1.0)
  when 'k'
    file[2].play(1.0, 1.0)
  when 'l'
    file[3].play(1.0, 1.0)
  when 'ö'
    file[4].play(1.0, 1.0)
  when 'ä'
    file[0].play(2.0, 1.0)
  when 'q'
    file[1].play(2.0, 1.0)
  when 'w'
    file[2].play(2.0, 1.0)
  when 'e'
    file[3].play(2.0, 1.0)
  when 'r'
    file[4].play(2.0, 1.0)
  when 't'
    file[0].play(3.0, 1.0)
  when 'z'
    file[1].play(3.0, 1.0)
  when 'u'
    file[2].play(3.0, 1.0)
  when 'i'
    file[3].play(3.0, 1.0)
  when 'o'
    file[4].play(3.0, 1.0)
  when 'p'
    file[0].play(4.0, 1.0)
  when 'ü'
    file[1].play(4.0, 1.0)
  else
    defined = false # only set background color value, if key is defined
  end
  @value = [rand(0..255), rand(0..255), rand(0..255)] if defined
end

def settings
  size 640, 360, P2D
end

