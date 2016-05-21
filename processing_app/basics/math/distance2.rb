# Distance 2D. 
# 
# Move the mouse across the image to obscure and reveal the matrix.  
# Measures the distance from the mouse to each square and sets the

def setup
  sketch_title 'Distance 2 D'
  no_stroke
  @max_distance = dist(0, 0, width, height)    
end

def draw  
  background 51  
  (0..width).step(20) do |i|  	
    (0..height).step(20) do |j|
      sz = dist(mouse_x, mouse_y, i, j) / @max_distance * 66
  		ellipse i, j, sz, sz
    end
  end  
end

def settings
  size 640, 360 
end
