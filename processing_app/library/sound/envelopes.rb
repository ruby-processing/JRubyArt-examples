load_library :sound

MESSAGE =<<-EOS
This sketch shows how to use envelopes and oscillators. Envelopes are
pre-defined amplitude distribution over time. The sound library
provides an ASR envelope which stands for attack, sustain, release.
The amplitude rises then sustains at the maximum level and decays
slowly depending on pre defined time segments.
       . ________
      .            ---
     .                 ---
    .                      ---
    A        S         R
EOS

%w[Env TriOsc].each do |klass|
  java_import "processing.sound.#{klass}"
end

attr_reader :triOsc, :env, :midi_sequence, :note, :trigger

# Times and levels for the ASR envelope
ATTACK_TIME = 0.001
SUSTAIN_TIME = 0.004
SUSTAIN_LEVEL = 0.3
RELEASE_TIME = 0.2
# This is an octave in MIDI notes.
DURATION = 200

def settings
  size(640, 360, P2D)
end

def setup
  sketch_title 'Envelopes'
  background(100, 100, 0)
  @midi_sequence = (60..72).to_a
  # Create triangle wave and start it
  @triOsc = TriOsc.new(self)
  #triOsc.play()
  # An index to count up the notes
  @note = 0
  # Create the envelope
  @env  = Env.new(self)
  # Set the note trigger
  @trigger = (Time.now.to_f * 1000).floor
  fill(0, 0, 100)
  message_font = create_font('SansSerif.plain', 18, true)
  text_font(message_font, 18)
end

def draw
  text(MESSAGE, 10, 20)
  # If the determined trigger moment in time matches up with the computer clock and we if the
  # sequence of notes hasn't been finished yet the next note gets played.
  if ((Time.now.to_f * 1000).floor > trigger) && (note < midi_sequence.length)
    # midi_to_freq transforms the MIDI value into a frequency in Hz which we use to control the triangle oscillator
    # with an amplitute of 0.8
    triOsc.play(midi_to_freq(midi_sequence[note]), 0.8)
    # The envelope gets triggered with the oscillator as input and the times and levels we defined earlier
    env.play(triOsc, ATTACK_TIME, SUSTAIN_TIME, SUSTAIN_LEVEL, RELEASE_TIME)
    # Create the new trigger according to predefined DURATIONs and speed it up by deviding by 1.5
    @trigger = (Time.now.to_f * 1000).floor + DURATION
    # Advance by one note in the midi sequence
    @note += 1
    # Loop the sequence, notice the jitter
    @note = 0 if note == 12
  end
end

# This function calculates the respective frequency of a MIDI note
def midi_to_freq(note)
  2**((note - 69) / 12.0) * 440
end
