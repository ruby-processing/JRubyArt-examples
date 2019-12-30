# frozen_string_literal: true

# Play a sound sample and pass it through a tape reverb, changing the reverb
# parameters based on the mouse position.
load_library :sound
java_import 'processing.sound.Reverb'
java_import 'processing.sound.SoundFile'

attr_reader :soundfile, :reverb

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Variable Reverb'
  # Load a soundfile
  @soundfile = SoundFile.new(self, data_path('vibraphon.aiff'))
  # Create the reverb effect
  @reverb = Reverb.new(self)
  # Play the file in a loop
  soundfile.loop
  # Connect the soundfile to the reverb unit
  reverb.process(soundfile)
end

def draw
  # Change the roomsize of the reverb
  room_size = map1d(mouseX, 0..width, 0..1.0)
  reverb.room(room_size)

  # Change the high frequency dampening parameter
  damping = map1d(mouseX, 0..width, 0..1.0)
  reverb.damp(damping)

  # Change the wet/dry relation of the effect
  effect_strength = map1d(mouseY, 0..height, 0..1.0)
  reverb.wet(effect_strength)
end
