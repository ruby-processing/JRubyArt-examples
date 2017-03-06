# How to make a wordcram that pops up extra information
# when you click on a word.
#
# Each frame, we want to draw the wordcram, and some info
# about the word that's been clicked on (or hovered over).
# Each frame, you need to clean up what the last frame drew.
#
# Since laying out a wordcram is expensive, and there's
# (currently) no way to quickly re-render a wordcram,
# we don't want to make the wordcram in draw().
# (Besides, each frame would probably come out different.)
# Instead, render the wordcram in the setup() method, and
# cache it as a PImage. Then, in draw(), render that image
# first, which will overlay the last frame's image.
require 'ruby_wordcram'

attr_reader :wc, :cached_image, :last_clicked_word

def settings
  size(700, 400)
end

def setup
  sketch_title 'Clickable Words'
  background(255)
  # Make the wordcram
  @wc = WordCram.new(self).from_web_page('http://wikipedia.org')
  wc.draw_all
  # Save the image of the wordcram
  @cached_image = get
  # Set up styles for when we draw stuff to the screen (later)
  text_font(create_font('sans', 150))
  text_align(CENTER, CENTER)
  @last_clicked_word = nil
end

def draw
  # First, wipe out the last frame: re-draw the cached image
  image(cached_image, 0, 0)
  # If the user's last click was on a word, render it big and blue:
  unless last_clicked_word.nil?
    no_stroke
    fill 255, 190
    rect 0, height / 2 - text_ascent / 2, width, text_ascent + text_descent
    fill(30, 144, 13, 150)
    text(last_clicked_word.word, width / 2, height / 2)
  end
end

def mouse_clicked
  @last_clicked_word = wc.get_word_at(mouse_x, mouse_y)
end
