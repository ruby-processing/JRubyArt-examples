######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriately yaml using ruby structs
# by Martin Prout after Dan Shiffman
####################################
load_library :bubble

attr_reader :bubble_data

def setup
  sketch_title 'Load & Save Struct Yaml'
  @bubble_data = BubbleData.new :bubbles
  bubble_data.load_data 'data/struct_data.yml'
end

def draw
  background 255
  bubble_data.display mouse_x, mouse_y
end

def settings
  size 640, 360, FX2D
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  bubble_data.create_new_bubble(mouse_x, mouse_y)
end

require 'forwardable'

# Enemerable class to store and display bubble data
class BubbleData
  include Enumerable
  extend Forwardable
  def_delegators(:@bubble_array, :clear, :each, :<<, :shift, :size)

  MAX_BUBBLE = 10

  attr_reader :path, :bubble_array
  def initialize(key)
    @bubble_array = []
    @key = key
  end

  def create_new_bubble(x, y)
    add Bubble.new(x, y, rand(40..80), 'new label')
    save_data
    load_data path
  end

  def add(bubble)
    self << bubble
    shift if size > MAX_BUBBLE
  end

  def load_data(path)
    @path = path
    yaml = Psych.load_file(path)
    # we are storing the data as an array of RubyStruct, in a hash with
    # a symbol as the key (the latter only to show we can, it makes no sense)
    data = yaml[@key]
    clear
    # iterate the bubble_data array, and populate the array of bubbles
    data.each do |pt|
      add Bubble.new(pt.x, pt.y, pt.diameter, pt.label)
    end
  end

  def display(x, y)
    each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end

  private

  def save_data
    hash = { @key => map(&:to_struct) }
    yaml = hash.to_yaml
    # overwite existing 'struct_data.yaml'
    open(path, 'w:UTF-8') { |f| f.write(yaml) }
  end
end
