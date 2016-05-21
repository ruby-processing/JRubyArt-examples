#
# After a HashMap example
# by Daniel Shiffman.
#
# This example demonstrates how to use a Hash to store
# a collection of objects referenced by a key. This is much like an array,
# only instead of accessing elements with a numeric index, we use a String.
# If you are familiar with associative arrays from other languages,
# this is the same idea.
#
# The Processing classes IntHash, FloatHash, and StringHash offer a simple
# way of pairing Strings with numbers or other Strings. But are probably of
# less interest to rubyists.
#
# In this example, words that appear in one book (Dracula) are colored white
# whilst words in the other book (Frankenstein) are colored black.
#
load_library 'word'

DRACULA = 'data/dracula.txt'
FRANKENSTEIN = 'data/frankenstein.txt'
DRAC = Regexp.new(DRACULA)
FRANK = Regexp.new(FRANKENSTEIN)

attr_accessor :words

def setup
  sketch_title 'Word Frequency'
  # Create the HashMap
  @words = {}
  # Load two files
  load_file(DRACULA)
  load_file(FRANKENSTEIN)
  # Create the font
  text_font(create_font('Georgia', 24))
end

def draw
  background(126)
  # Show words
  words.values.each do |w|
    if w.qualify?
      w.display
      w.move
    end
  end
end

# Load a file
def load_file(filename)
  tokens = File.open(filename, 'r') { |file| file.read.scan(/[\w'-]+/) }
  tokens.each do |s|
    s = s.downcase
    # Is the word in the HashMap
    if words.key?(s)
      # Get the word object and increase the count
      # We access objects from a Hash via its key, the String
      w = words[s]
      # Which book am I loading?
      if !DRAC.match(filename).nil?
        w.increment_dracula
      elsif !FRANK.match(filename).nil?
        w.increment_franken
      end
    else
      # Otherwise make a new word
      w = Word.new(self, s)
      # And add entry to the Hash
      # The key for us is the String and the value is the Word object
      words[s] = w
      if DRAC.match(filename)
        w.increment_dracula
      elsif FRANK.match(filename)
        w.increment_franken
      end
    end
  end
end

def settings
  size(640, 360)
end

