# Recursion2

def setup
  sketch_title 'Recursion 2'
  no_stroke   
  draw_circle 280, 180, 150, 8
end

def draw_circle (x, y, radius, level)    
  tt = 126 * level / 6.0
  fill tt, 153  	
  ellipse x, y, radius * 2, radius * 2  	
  return unless level > 1  	    
  level = level - 1
  num = rand(2..6)  		
  0.upto(num - 1) do |i|  			
    a = rand(0..360)
    nx = x + DegLut.cos(a) * 8.0 * level
    ny = y + DegLut.sin(a) * 6.0 * level
    draw_circle nx, ny, radius / 2, level
  end
end

def settings
  size 640, 360
end
