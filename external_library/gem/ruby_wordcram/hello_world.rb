# This apparently basic sketch demonstrates how we need to be careful in passing
# ruby arrays to java methods (to be safe they should be cast `to_java(klass)`)
# Also thanks to some forethought from the WordCram author we can often chain
# methods [:new, :from_words, :draw_all] like the 'hype' library.
require 'ruby_wordcram'

def settings
  size 700, 400
end

def setup
  sketch_title 'Hola Mundo!'
  background 255
  # Each Word object has its word, and its weight.  You can use whatever
  # numbers you like for their weights, and they can be in any order.
  word_array = [Word.new('Hello', 100), Word.new('WordCram', 60)].to_java(Word)
  # Pass in the sketch (the variable 'self'), so WordCram can draw to it.
  wordcram = WordCram.new(self)
                     .from_words(word_array) # Pass in the words to draw.
                     .draw_all # Now we've created our WordCram, we can draw it
end
