require 'cf3'

#######################################################
# This sketch takes some time to develop,             #
# clicking the mouse, allows you view current state   #
# in the final state background will be green         #
#######################################################

def setup_the_fern
  
  @fern = ContextFree.define do
    shape :start do
      fern rotation: 8, hue: 306
    end
    shape :fern do
      square size: 0.75, rotation: -49
      split do
        fern size: 0.92, y: -2, rotation: 5, hue: 306
        rewind
        fern size: 0.5, y: -2, rotation: 90
        rewind                                  
        fern size: 0.5, y: -2, rotation: -90
      end
    end
  end
end

def settings
  size 600, 600
end

def setup
  sketch_title 'Fern'
  setup_the_fern
  no_stroke
end

def draw
  # Do nothing.
end

def draw_it
  background 119, 0.25, 0.2, 1.0
  @fern.render :start, size: height/23, color: [126, 0.4, 0.9, 0.55], stop_size: 1,
                       start_x: width/2.5, start_y: height/1.285
end

def mouse_clicked
  draw_it
end
