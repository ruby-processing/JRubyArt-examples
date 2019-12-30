# frozen_string_literal: true

# Play a sound sample and pass it through a tape delay, changing the delay
# parameters based on the mouse position.
load_library :sound
java_import 'processing.sound.Delay'
java_import 'processing.sound.SoundFile'

attr_reader :soundfile, :delay

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Variable Delay'
  # Load a soundfile
  @soundfile = SoundFile.new(self, data_path('vibraphon.aiff'))
  # Create the delay effect
  @delay = Delay.new(self)
  # Play the file in a loop
  soundfile.loop
  # Connect the soundfile to the delay unit, which is initiated with a
  # five second "tape"
  delay.process(soundfile, 5.0)
end

def draw
  # Map mouseX from -1.0 to 1.0 for left to right panning
  position = map1d(mouseX, 0..width, -1.0..1.0)
  soundfile.pan(position)
  # Map mouseX from 0 to 0.8 for the amount of delay feedback
  fb = map1d(mouseX, 0..width, 0.0..0.8)
  delay.feedback(fb)
  # Map mouseY from 0.001 to 2.0 seconds for the length of the delay
  delay_time = map1d(mouseY, 0..height, 0.001..2.0)
  delay.time(delay_time)
end
