require 'cf3'

load_library 'control_panel'

attr_accessor :resolution

def setup_the_triangle
  @triangle = ContextFree.define do
    shape :tri do
      triangle size: 0.5
      split do
        tri size: 0.5, y: -0.578, x: 0,
        hue: 288, saturation: 0.2, brightness: 0.8
        rewind
        tri size: 0.5, y: 0.289, x: -0.5, hue: 72,
        saturation: 0.2, brightness: 0.8
        rewind
        tri size: 0.5, y: 0.289, x: 0.5, hue: 72,
        saturation: 0.2, brightness: 0.8
      end
    end
  end
end

def settings
  size 600, 600
end

def setup
  sketch_title 'Sierpinski'
  control_panel do |panel|
    panel.title 'Adjust'
    panel.slider :resolution, (2.0..50)
  end
  setup_the_triangle
  no_stroke
end

def draw
  background 0.1
  @triangle.render :tri, size: height/1.1, color: [0, 0.5, 1.0, 1.0], stop_size: @resolution, start_y: height/1.65
end
