# by Martin Prout
require 'cf3'
def setup_the_sun
  @sun = ContextFree.define do
    shape :start do
      rot = 0
      split do
        12.times do
          legs rotation: rot
          rot += 30
          rewind
        end
        legs rotation: 360
      end
    end

    shape :legs do
      circle
      legs rotation: 1, y: 0.1,
      size: 0.973, color: [0.22, 0.15]
    end
  end
end

def settings
  size 600, 600
end

def setup
  sketch_title 'Dark Star'
  setup_the_sun
  no_stroke
  color_mode HSB, 1.0
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 0.7
  @sun.render :start, size: height/7,  stop_size: 0.8,
  start_x: width/2, start_y: height/2
end
