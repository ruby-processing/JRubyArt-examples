#
# Loading doc Data
# by Daniel Shiffman.
#
# This example demonstrates how to use loaddoc
# to retrieve data from an doc file and make objects
# from that data.
#
# Here is what the doc looks like:
#
# <?doc version='1.0'?>
# <bubbles>
#  <bubble>
#    <position x='160' y='103'/>
#    <diameter>43.19838</diameter>
#    <label>Happy</label>
#  </bubble>
#  <bubble>
#    <position x='372' y='137'/>
#    <diameter>52.42526</diameter>
#    <label>Sad</label>
#  </bubble>
# </bubbles>
#
require 'nokogiri'
load_library 'bubble'

attr_reader :bubbles

def setup
  sketch_title 'Load save Nokogiri'
  load_data
end

def draw
  background(255)
  # Display all bubbles
  bubbles.each do |b|
    b.display
    b.rollover(mouse_x, mouse_y)
  end
  text_align(LEFT)
  fill(0)
  text('Click to add bubbles.', 10, height - 10)
end

def load_data
  # Load doc file
  file = File.open(data_path('data.xml'), 'r')
  doc = Nokogiri.XML(file)
  sketch_title 'Load & Save doc'
  # total doc elements named 'bubble'
  @bubbles = []
  doc.xpath("*[//bubble]").each do |b|
    diameter = b.at_xpath("//diameter").content.to_f
    label = b.at_xpath("//label").content
    position = b.at_xpath("//position")
    x = position['x'].value.to_f
    y = position['y'].value.to_f
    # Make a Bubble object out of the data read
    bubbles << Bubble.new(x, y, diameter, label)
  end
  file.close
end

def settings
  size(640, 360)
end
