# vine.rb by jashkenas, click mouse to re-run
require 'cf3'

def setup_the_vine
  @vine = ContextFree.define do
    shrink = 0.961
    shape :root do
      split do
        shoot y: 1
        rewind
        shoot rotation: 180
      end
    end
    
    shape :shoot do
      square
      shoot y: 0.98, rotation: 5, size: shrink + rand * 0.05, brightness: 0.990
    end

    shape :shoot, 0.02 do
      square
      split do
        shoot rotation: 90
        rewind
        shoot rotation: -90
      end
    end
  end
end

def settings
  size 700, 700
end

def setup
  sketch_title 'Vine'
  setup_the_vine
  no_stroke
end

def draw
  # Do nothing.
end

def draw_it
  background 270, 1.0, 0.15, 1.0
  @vine.render :root, size: height/75, color: [270, 0.1, 0.9, 1.0],
                     start_x: width/2, start_y: height/2
end

def mouse_clicked
  draw_it
end
