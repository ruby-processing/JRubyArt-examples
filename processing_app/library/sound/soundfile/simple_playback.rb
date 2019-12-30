# frozen_string_literal: true

# This is a simple sound file player. Use the mouse position to control playback
# speed, amplitude and stereo panning.
load_library :sound
java_import 'processing.sound.SoundFile'

attr_reader :soundfile

def settings
  size(640, 360)
end

def setup
  size(640, 360)
  sketch_title 'Play Sound File'
  background(255)
  # Load a soundfile
  @soundfile = SoundFile.new(self, data_path('vibraphon.aiff'))
  # These methods return useful infos about the file
  puts("SFSampleRate= #{soundfile.sampleRate} Hz")
  puts("SFSamples= #{soundfile.frames} samples")
  puts("SFDuration= #{soundfile.duration} seconds")
  # Play the file in a loop
  soundfile.loop
end

def draw
  # Map mouseX from 0.25 to 4.0 for playback rate. 1 equals original
  # playback speed, 2 is twice the speed and will sound an octave
  # higher, 0.5 is half the speed and will make the file sound one
  # octave lower.
  playback_speed = map1d(mouse_x, 0..width, 0.25..4.0)
  soundfile.rate(playback_speed)
  # Map mouseY from 0.2 to 1.0 for amplitude
  amplitude = map1d(mouse_y, 0..width, 0.2..1.0)
  soundfile.amp(amplitude)
  # Map mouseY from -1.0 to 1.0 for left to right panning
  panning = map1d(mouse_y, 0..height, -1.0..1.0)
  soundfile.pan(panning)
end
