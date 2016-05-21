# encoding: utf-8
# frozen_string_literal: true
load_library :slider
attr_reader :color1, :color2, :color3, :r, :gs, :b, :back

def settings
  size(600, 400)
  smooth(4)
end

def setup 
  sketch_title 'Slider Sample'
  @back = true
  @r, @gs, @b = 0, 0, 0
  @color1 = Slider.slider(
    app: self,
    x: 77,
    y: 200,
    name: 'Slider 1',
    initial_value: 50
  )
  @color2 = Slider.slider(
    app: self,
    x: 77,
    y: 230,
    name: 'Slider 2',
    initial_value: 50
  )
  @color3 = Slider.slider(
    app: self,
    x: 77,
    y: 260,
    name: 'Slider 3'
  )
  color_mode(RGB, 100)
end

def draw
  background(b, r, gs)
  fill(r, gs, b)
  ellipse(300, 200, 300, 300)
  @r = color1.read_value
  @gs = color2.read_value
  @b = color3.read_value
end

