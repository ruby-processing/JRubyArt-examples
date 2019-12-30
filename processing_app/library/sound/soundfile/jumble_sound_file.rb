# frozen_string_literal: true

# First load a sample sound soundfile from disk, then start manipulating it
# using the low-level data access functions provided by SoundFile.
# With every mouseclick, two random 1 second chunks of the sample are
# swapped around in their position. The sample always stays the same
# length and it keeps on looping, but the more often you do random
# swaps, the more the original soundfile gets cut up into smaller and
# smaller portions that seem to be resampled at random
load_library :sound
java_import 'processing.sound.SoundFile'

attr_reader :soundfile, :file_length

def settings
  size(640, 360)
end

def setup
  sketch_title 'press mouse to jumble sounds'
  background(255)
  # Load a soundfile
  @soundfile = SoundFile.new(self, data_path('beat.aiff'))
  @file_length = soundfile.sample_rate
  # Jumble the soundfile in a loop
  soundfile.loop
end

def mouse_pressed
  # Every time the mouse is pressed, take two random 1 second chunks
  # of the sample and swap them around.
  chunk_one_start = rand(soundfile.frames)
  offset = rand(soundfile.frames - file_length)
  # Offset part two by at least one second
  chunk_two_start = chunk_one_start + file_length + offset
  # Make sure the start of the second sample part is not past the end
  # of the soundfile.
  chunk_two_start = chunk_two_start % soundfile.frames
  # Read one second worth of frames from each position
  chunk_one = Array.new(file_length, 0.0).to_java(:float)
  chunk_two = Array.new(file_length, 0.0).to_java(:float)
  soundfile.read(chunk_one_start, chunk_one, 0, file_length)
  soundfile.read(chunk_two_start, chunk_two, 0, file_length)
  # And write them back the other way around
  soundfile.write(chunk_one_start, chunk_two, 0, file_length)
  soundfile.write(chunk_two_start, chunk_one, 0, file_length)
end

def draw
end
