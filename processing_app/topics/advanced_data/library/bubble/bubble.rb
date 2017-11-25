# encoding: utf-8
# frozen_string_literal: true
# The bubble library
class Bubble
  include Processing::Proxy

  attr_reader :x, :y, :diameter, :label, :over

  # Create  the Bubble
  def initialize(x, y, diameter, label)
    @x = x
    @y = y
    @diameter = diameter
    @label = label
    @over = false
  end

  # Checking if mouse is over the Bubble
  def rollover(px, py)
    d = dist(px, py, x, y)
    @over = (d < diameter / 2.0) ? true : false
  end

  # Display the Bubble
  def display
    stroke(0)
    stroke_weight(2)
    noFill
    ellipse(x, y, diameter, diameter)
    return unless over
    fill(0)
    text_align(CENTER)
    text(label, x, y + diameter / 2 + 20)
  end

  def to_a
    [x, y, diameter, label]
  end

  def to_struct
    BubbleStruct.new(x, y, diameter, label)
  end
end
