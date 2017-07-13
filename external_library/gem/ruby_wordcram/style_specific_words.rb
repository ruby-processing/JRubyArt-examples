require 'ruby_wordcram'

LETTERS = ('A'..'Z').to_a
WEIGHTING = (1..26).to_a.reverse
VALUES = LETTERS.zip(WEIGHTING).to_h

def settings
  size(600, 350)
end

def setup
  sketch_title 'Style Specific Words'
  background(255)
  alphabet = LETTERS.map do |letter|
    Word.new(letter, VALUES[letter])
  end
  # If you're passing your own weighted words to
  # WordCram, you can control how specific words
  # are styled. The regular methods will still work,
  # but if a Word has style pre-set_s, they'll
  # override whatever style rules are in place.
  #
  # In the example below, the letters are colored
  # black, in the default font, up-side down, and
  # placed on a wave - except for A and Z.
  a = alphabet[0]
  a.set_color(color('#FF0000'))
  a.set_angle(20.radians)
  a.set_font(create_font(data_path('MINYN___.TTF'), 1))
  a.set_place(340, 200)
  a.set_size(160)
  # You can also chain your calls, like you do with WordCram.
  z = alphabet[25]
  z.set_color(color('#0000FF'))
   .set_angle(-20.radians)
   .set_font(create_font('Georgia', 1))
   .set_place(180, 40)
   .set_size(130)
  WordCram.new(self)
          .from_words(alphabet.to_java(Word))
          .angled_at(-PI)
          .with_placer(Placers.wave)
          .draw_all
end
