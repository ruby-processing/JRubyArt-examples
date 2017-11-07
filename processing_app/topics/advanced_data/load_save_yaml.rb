######################################
# Yet another examples of reading and
# writing to some form of markup,
# appropriately yaml.
# by Martin Prout after Dan Shiffman
# ###################################
require 'forwardable'
require 'psych'
load_library :bubble

attr_reader :bubble_data

def setup
  sketch_title 'Load Save Yaml'
  # load data from file
  @bubble_data = BubbleData.new 'bubbles'
  bubble_data.load_data(data_path('data.yml'))
end

def draw
  background 255
  bubble_data.display mouse_x, mouse_y
end

def mouse_pressed
  # create a new bubble instance, where mouse was clicked
  @bubble_data.create_new_bubble(mouse_x, mouse_y)
end

# Bubble class can create and display bubble data from a yaml file
class BubbleData
  extend Forwardable
  def_delegators(:@bubbles, :each, :size)
  include Enumerable

  MAX_BUBBLE = 10

  attr_reader :key
  def initialize(key)
    @bubbles = []
    @key = key
    super
  end

  def create_new_bubble(x, y)
    add(Bubble.new(x, y, rand(40..80), 'new label'))
    save_data
    load_data path
  end

  def display(x, y)
    each do |bubble|
      bubble.display
      bubble.rollover(x, y)
    end
  end

  # @param path to yaml file
  def load_data(path)
    yaml = Psych.load_file(path)
    data = yaml[key]
    clear
    # iterate the bubble_data array, and create an array of bubbles
    data.each do |point|
      add Bubble.new(
        point['position']['x'],
        point['position']['y'],
        point['diameter'],
        point['label'])
      end
    end

    def add(bubble)
      bubbles << bubble
      bubbles.shift if bubbles.size > MAX_BUBBLE
    end

    private

    def save_data
      hash = { key => map(&:to_hash) }
      # overwite existing 'data.yaml'
      File.write(data_path('data.yml'), hash.to_yaml)
    end
  end

  def settings
    size 640, 360
  end
