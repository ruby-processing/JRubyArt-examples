# This example demonstrates how 'sketch data' can be retrieved from a json file
# in JRubyArt. Note this sketch re-uses the Bubble class from the bubble
# library. The BubbleData class, can load, store and create instances of Bubble
# (and request them to display and/or show their label, when 'mouse over').
# @author Martin Prout, after Daniel Shiffmans version for processing
require 'forwardable'
require 'json'

load_library :bubble

attr_reader :bubble_data

def setup
  sketch_title 'Load save json'
  # initialize bubble_data with 'key' and read data from 'file path'
  @bubble_data = BubbleData.new 'bubbles'
  bubble_data.load_data 'data/data.json'
end

def draw
  background 255
  # draw the bubbles and display a bubbles label whilst mouse over
  bubble_data.display mouse_x, mouse_y
end

def settings
  size 640, 360, FX2D
end

def mouse_pressed
  # create a new instance of bubble, where mouse was clicked
  bubble_data.create_new_bubble(mouse_x, mouse_y)
end

# This class can load store and create instances of Bubble, the enumerable
# acts like a circular buffer MAX_BUBBLE size
class BubbleData
  extend Forwardable
  def_delegators(:@bubbles, :each, :map, :size, :shift, :clear)
  include Enumerable

  MAX_BUBBLE = 10

  attr_reader :key, :path, :bubbles

  # @param key String for top level hash

  def initialize(key)
    @key = key
    @bubbles = []
  end

  def create_new_bubble(x, y)
    self << Bubble.new(x, y, rand(40..80), 'new label')
    save_data
    load_data path
  end

  def display(x, y)
    each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end

  # @param path to json file

  def load_data(path)
    @path = path
    file = File.read(path)
    data = JSON.parse(file)[key]
    clear
    # iterate the bubble_data array, and create an array of bubbles
    @bubbles = data.map do |point|
      Bubble.new(
        point['position']['x'],
        point['position']['y'],
        point['diameter'],
        point['label'])
      end
  end

  def <<(bubble)
    bubbles << bubble
    shift if size > MAX_BUBBLE
  end

  private

  def save_data
    hash = { key => map(&:to_hash) }
    File.open(path, 'w') do |json|
      json.write(JSON.pretty_generate(hash)) # generate pretty output
    end
  end
end
