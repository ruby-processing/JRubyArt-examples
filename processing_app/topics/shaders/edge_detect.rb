#
# Edge Detection
# 
# Change the default shader to apply a simple, custom edge detection filter.
# 
# Press the mouse to switch between the custom and default shader.
#
attr_reader :edges, :img , :enabled


def setup
  sketch_title 'Edge detect'
  @enabled = true
  @img = load_image(data_path('leaves.jpg'))    
  @edges = load_shader(data_path('edges.glsl'))
  # @img = load_image('leaves.jpg') # use --noruby flag      
  # @edges = load_shader('edges.glsl') # use --nojruby flag
end

def draw
  shader(edges) if enabled
  image(img, 0, 0)
end

def mouse_pressed
  @enabled = !enabled
  if (!enabled == true)
    reset_shader
  end
end

def settings
  size(640, 360, P2D)
end
