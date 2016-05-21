require 'cf3'
#######
# Simple example demonstrating rewind
# also how to make simple composite shapes
# from primitive terminals (renders on mouse clicked)
###

def setup
  size 400, 200 
  @stars = ContextFree.define do
    
    shape :stars do
      split do
        sqstar size: 0.8, x: -1
        rewind
        trstar x: 1
      end
    end
    
    shape :sqstar do
      square
      square rotation: 45
    end
    
    shape :trstar do
      triangle
      triangle rotation: 180
    end
  end 
end

def draw_it
  background 0.2 
  @stars.render :stars, size: height/2, color: [220, 1, 1, 1]
end

def draw
  # Do nothing.
end

def mouse_clicked
  draw_it
end
