# frozen_string_literal true

# This example shows how to make a simple sampler and sequencer with the
# Sound library. Five different samples are loaded and played back at
# different pitches, in this case 5 different octaves. The sequencer
# randomly triggers an event every 200-1000 mSecs. Each time a sound is
# played a colored rect with a random color is displayed.
load_library :sound
java_import 'processing.sound.SoundFile'
NUM_SOUND = 5
OCTAVE = [0.25, 0.5, 1.0, 2.0, 4.0].freeze
POSX = [0, 128, 256, 384, 512].freeze
attr_reader :files, :trigger, :play_sound

def settings
  size(640, 360)
end

def setup
  sketch_title 'Sampler'
  background(255)
  color_mode HSB, 360.0, 1.0, 1.0
  # Load the soundfiles from data folder
  @files = (0...NUM_SOUND).map do |i|
    SoundFile.new(self, data_path("#{i.succ}.aif"))
  end
  @trigger = millis
  @play_sound = Array.new(NUM_SOUND, 1)
end

def draw
  if millis > trigger

    background 255
    NUM_SOUND.times do |i|
      unless play_sound[i].zero?
        fill rand(360), 1.0, 1.0
        no_stroke
        rect(POSX[i], 50, 128, 260)
        rate = OCTAVE.sample
        files[i].play(rate, 1.0)
      end
      play_sound[i] = rand(0..1)
    end
  end
  @trigger = millis + rand(200..1000)
end
