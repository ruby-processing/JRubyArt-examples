# encoding: utf-8
# frozen_string_literal: true
# Description:
# This is a full-screen demo 
# Since processing-3.0a10 set in settings

class FullScreen < Processing::App
  attr_reader :dim, :rnd
  def setup
    sketch_title 'Plain'
    @dim = height / 6
    @rnd = dim / 10
  end

  def draw
    background 200
    fill 120, 160, 220
    stroke 0
    rect_mode(CENTER)
    (dim..width - dim).step(dim) do |x|
      (dim..height - dim).step(dim) do |y|
        rect x, y, dim, dim, rnd, rnd, rnd, rnd 
      end
    end
  end  

  def settings
    full_screen
  end
end

