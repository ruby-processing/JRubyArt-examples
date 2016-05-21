#######
# word.rb
# the word class stores data about words (text, source, frequency)
# thanks to processing mixin words are rendered according to
# source and frequency
########
class Word
  include Processing::Proxy
  # Store a count for occurences in two different books
  attr_reader :count_dracula, :count_franken, :total_count
  attr_reader :word, :position, :width, :height, :speed

  def initialize(app, s)
    @width, @height = app.width, app.height
    @count_dracula, @count_franken, @total_count = 0, 0, 0
    @position = [rand(width), rand(-height..height * 2)]
    @word = s
  end

  # We will display a word if it appears at least 5 times
  # and only in one of the books
  def qualify?
    ((count_dracula == total_count || count_franken == total_count) &&
      total_count > 5)
  end

  # Increment the count for Dracula
  def increment_dracula
    @count_dracula += 1
    @total_count += 1
  end

  # Increment the count for Frankenstein
  def increment_franken
    @count_franken += 1
    @total_count += 1
  end

  # The more often it appears, the faster it falls
  def move
    @speed = map1d(total_count, (5..25), (0.1..0.4))
    @speed = constrain(speed, 0, 10.0)
    @position[Y] += speed
    @position[Y] = -height if position[Y] > height * 2
  end

  # Depending on which book it gets a color
  def display
    if count_dracula > 0
      fill(255)
    elsif count_franken > 0
      fill(0)
    end
    # Its size is also tied to number of occurences
    fs = map1d(total_count, (5..25), (2..24.0))
    fs = constrain(fs, 2, 48)
    text_size(fs)
    text_align(CENTER)
    text(word, position[X], position[Y])
  end
end
