# encoding: utf-8
# frozen_string_literal: true
load_library :slider
attr_reader :color1, :color2, :color3, :r, :gs, :b, :back

def settings
  size(600, 400)
  smooth(4)
end

def setup
  sketch_title 'Slider Demo'  
  @back = true
  @r, @gs, @b = 0, 0, 0
  @color1 = Slider.slider(
    app: self,
    vertical: true,
    x: 100,
    y: 77,
    length: 200,
    range: (-125.0..125.0),
    name: 'Slider 1',
    inital_value: 10
  )
  @color2 = Slider.slider(
    app: self,
    vertical: true,
    x: 256,
    y: 77,
    length: 200,
    range: (0..255),
    name: 'Slider 2',
    initial_value: 180
  )
  @color3 = Slider.slider(
    app: self,
    vertical: true,
    x: 410,
    y: 77,
    length: 200,
    range: (0.0..255.0),
    name: 'Slider 3',
    initial_value: 134
  )
  color1.bar_width(100)
  color1.widget_colors(color('#930303'), color('#FF0000'))
  color2.bar_width(100)
  color2.widget_colors(color('#5BCE4D'), color('#1CFF00'))
  color3.bar_width(100)
  color3.widget_colors(color('#4439C9'), color('#9990FF'))
end

def draw
  background(r + 125, gs, b)
  @r = color1.read_value
  @gs = color2.read_value
  @b = color3.read_value
end

