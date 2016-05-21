#
# Loading Tabular Data
# after Daniel Shiffman, by Martin Prout.
#
# This example demonstrates how to use CSV
# to retrieve data from a CSV file and make objects
# from that data.
#
# Here is what the CSV looks like:
#
#   x,y,diameter,name
#   160,103,43.19838,Happy
#   372,137,52.42526,Sad
#   273,235,61.14072,Joyous
#   121,179,44.758068,Melancholy
#
require 'csv'

load_library 'bubble'

attr_reader :bubbles, :data

def setup
  sketch_title 'Load save table'
  load_data
end

def settings
  size(640, 360)
end

def draw
  background(255)
  # Display all bubbles
  bubbles.run
  text_align(LEFT)
  fill(0)
  text('Click to add bubbles.', 10, height - 10)
end

def load_data
  # Load CSV file into an Array of Hash objects
  # headers: option indicates the file has a header row
  @bubbles = BubbleData.new
  CSV.foreach('data/data.csv', headers: true) do |row|
    x = row['x'].to_f
    y = row['y'].to_f
    d = row['diameter'].to_f
    n = row['name']
    # Make a Bubble object out of the data read
    bubbles << Bubble.new(x, y, d, n)
  end
end

def mouse_pressed
  bubbles << Bubble.new(mouse_x, mouse_y, rand(40..80), 'blah')
  # If there are more than 10 bubbles delete the oldest bubble
  bubbles.shift if bubbles.size > 10
  # Writing the csv data back to the same file, (also specify UTF-8 format)
  headers = %w(x y diameter name) # create csv headers
  CSV.open(
    'data/data.csv',
    'w:UTF-8',
    write_headers: true,
    headers: headers
  ) do |csv|
    bubbles.each do |bubble|
      csv << bubble.to_a # write back bubble data
    end
  end
  load_data
end

# A run module
module Runnable
  def run
    each(&:display)
    each { |item| item.rollover(mouse_x, mouse_y) }
  end
end

# Enumerable class holds bubble data
class BubbleData
  extend Forwardable
  def_delegators(:@bubbles, :each, :<<, :size, :shift)
  include Enumerable, Runnable

  def initialize
    @bubbles = []
  end
end
