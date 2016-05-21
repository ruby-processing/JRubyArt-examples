attr_reader :nebula

def setup
  sketch_title 'Nebula'
  @nebula = load_shader('nebula.glsl')
  nebula.set('resolution', width.to_f, height.to_f) 
end

def draw
  nebula.set('time', millis / 1000.0)
  shader(nebula)
  # The rect is needed to make the fragment shader go through every pixel of
  # the screen, but is not used for anything else since the rendering is entirely
  # generated by the shader.
  no_stroke
  fill(0)
  rect(0, 0, width, height)  
end

def settings
  size(512, 384, P2D)
end
