# y.rb JRubyArt by Martin Prout
require 'cf3'
Y_TOP = -1 / Math.sqrt(3) 
Y_BOT = Math.sqrt(3) / 6

def setup_the_triangle
  @triangle = ContextFree.define do
    ########  
    shape :start do
    unit brightness: 1.0
    end
    
    shape :unit do
      triangle size: 1.0
      split do
        unit size: 0.5, x: 0, y: Y_TOP/2, brightness: 0.8
        rewind 
        unit size: 0.5, x: -0.25, y: -Y_TOP/4, brightness: 0.8        
        rewind
        unit size: 0.5, x: 0.25, y: -Y_TOP/4, brightness: 0.8
      end
    end
    ########
  end
end

def settings
  size 1024, 1024
end
                
def setup
  sketch_title 'Y' 
  setup_the_triangle
  no_stroke
  color_mode RGB, 1  
  draw_it
  save_frame('y.png')
end


def draw
   # Do nothing.
end

def draw_it
  background 225, 225, 0
  @triangle.render :start, size: height, stop_size: 0.5,
  start_x: width/2, start_y: height * 0.6
end
