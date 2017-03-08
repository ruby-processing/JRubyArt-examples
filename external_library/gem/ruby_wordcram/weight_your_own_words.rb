require 'ruby_wordcram'

LETTERS = ('A'..'Z').to_a
WEIGHTING = (1..26).to_a.reverse
VALUES = LETTERS.zip(WEIGHTING).to_h

def settings
  size(600, 350)
end

def setup
  sketch_title 'Custom Weightings'
  background(255)
  # You can do more than count up words in a
  # document - you can pass your own weighted
  # words to WordCram, in an array. They can be
  # anything: professional athletes weighted by
  # points scored or minutes of playtime,
  # politicians weighted by how often they vote
  # against party lines, or nations weighted by
  # population, area, or GDP.
  alphabet = LETTERS.map do |letter|
    Word.new(letter, VALUES[letter])
  end

  WordCram.new(self)
  .from_words(alphabet.to_java(Word))
  .draw_all
end
