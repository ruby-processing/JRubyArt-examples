#########################
# rubystar.rb 
# Adding two custom "triangle" shapes.
# These flat and sharp primitives are
# used to make dart and kite shapes (for penrose?)
#########################
require 'cf3'

PHI = (1 + Math.sqrt(5)) / 2

def setup_the_sunstar
  @hexa = ContextFree.define do
  ############ Begin defining custom terminals, as a sharp and flat triangles 
    class << self
    include Math
      define_method(:sharp) do |some_options|      
        size, options = *self.get_shape_values(some_options)
        rot = options[:rotation]
        rotate(rot) if rot           # NB: sin(0) = 0, cos(0) = 1                                         
        @app.triangle(0, 0, size, 0, size * cos(PI/5), size * sin(PI/5))
        rotate(-rot) if rot
      end
      define_method(:flat) do |some_options|      
        size, options = *self.get_shape_values(some_options)
        rot = options[:rotation]
        rotate(rot) if rot
        f = (options[:flip])? -1 : 1  # flip adjustment NB: sin(0) = 0, cos(0) = 1
        @app.triangle(0, 0, size/PHI, 0, size * cos(PI * f/5), size * sin(PI * f/5))
        rotate(-rot) if rot
      end
    end
    ########### End definition of custom terminals 'sharp and flat'
    shape :tiling do    
      sun brightness: 0.8
      star brightness: 0.8, alpha: 0.8
      tiling size: 1/PHI, brightness: 1.0
    end
  
    shape :dart do
      flat size: 1, color: [65, 0.6, 0.6, 1]
      flat size: 1, color: [65, 1.0, 1.0, 1], flip: true
    end
  
    shape :kite do
      sharp size: 1, color: [0, 0.6, 0.6, 1]
      sharp size: 1, color: [0, 1.0, 1.0, 1], rotation: 180, flip: true
    end
  
    shape :star do    
      split do
        5.times do |i|
          dart rotation: 72 * i 
          rewind
        end
      end
    end
  
    shape :sun do
      split do
        5.times do |i|
          kite rotation: 72 * i
          rewind
        end
      end
    end
  end
end

def setup
  size 800, 800
  background 150, 20, 0, 1
  setup_the_sunstar
  draw_it
end

def draw_it
  @hexa.render :tiling, start_x: width/2, start_y: height/2, 
               size: height 
end
