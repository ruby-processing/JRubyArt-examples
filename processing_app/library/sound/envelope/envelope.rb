# frozen_string_literal: true

# Grab audio from the microphone input and draw a circle whose size
# is determined by how loud the audio input is.
load_library :sound
java_import 'processing.sound.Env'
java_import 'processing.sound.TriOsc'
# This is an octave in MIDI notes.
MIDI_SEQUENCE = [60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72].freeze
# Times and levels for the ASR envelope
ATTACK_TIME = 0.001
DURATION = 200
SUSTAIN_TIME = 0.004
SUSTAIN_LEVEL = 0.3
RELEASE_TIME = 0.2

attr_reader :envelope, :note, :oscillator, :trigger

def settings
  size(640, 360)
end

def setup
  background(255)
  sketch_title 'Envelope'
  @note = 0
  @envelope = Env.new(self)
  @oscillator = TriOsc.new(self)
  @trigger = millis
end

def draw
  # If the determined trigger moment in time matches up with the computer clock and
  # the sequence of notes hasn't been finished yet, the next note gets played.
  if (millis > trigger) && (note < MIDI_SEQUENCE.length)
    # midiToFreq transforms the MIDI value into a frequency in Hz which we use to
    # control the triangle oscillator with an amplitute of 0.5
    oscillator.play(midi_to_freq(MIDI_SEQUENCE[note]), 0.8)
    # The envelope gets triggered with the oscillator as input and the times and
    # levels we defined earlier
    envelope.play(oscillator, ATTACK_TIME, SUSTAIN_TIME, SUSTAIN_LEVEL, RELEASE_TIME)
    # Create the new trigger according to predefined duration
    @trigger = millis + DURATION
    # Advance by one note in the MIDI_SEQUENCE
    @note += 1
    # Loop the sequence, notice the jitter
    @note = 0 if note == 12
  end
end

# This helper function calculates the respective frequency of a MIDI note
def midi_to_freq(note)
  ((note - 69) / 12.0)**2 * 440
end
