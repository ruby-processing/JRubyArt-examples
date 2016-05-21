require 'cf3' 

load_library 'control_panel'

attr_accessor :resolution, :panel, :hide

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
  setup_the_triangle
  no_stroke
  @hide = false
  @resolution = 5
  control_panel do |p|
    p.look_feel 'Metal'	# optional set look and feel  
    p.slider :resolution, (2..50), 5
    @panel = p
  end
end

def draw
  unless hide	
    panel.set_visible(true) # display panel after sketch frame
    @hide = true
  end
  background 0.1
  @triangle.render :tri, size: height/1.1, color: [0, 0.5, 1.0, 1.0], stop_size: @resolution, start_y: height/1.65
end

def mouse_clicked
  @hide = false	
end
