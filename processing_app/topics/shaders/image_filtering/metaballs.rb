
# Note: this filter is meant to be used on black & white images

# The 2D metaball filter is a combination of blur and threshold
attr_reader :gaussian_blur, :threshold

def setup
  sketch_title 'Metaballs'
  # Load and configure the filters
  @gaussian_blur = load_shader('gaussianBlur.glsl')
  gaussian_blur.set('kernelSize', 32) # How big is the sampling kernel?
  gaussian_blur.set('strength', 7.0) # How strong is the blur?  
  @threshold = load_shader('threshold.glsl')
  threshold.set('threshold', 0.5)
  threshold.set('antialiasing', 0.05) # values between 0.00 and 0.10 work best  
end

def draw   
  background(255)  
  # Draw some moving circles
  translate(width / 2,height / 2)
  no_stroke
  fill(0)
  ellipse(0, 0, 100, 100)
  x = map1d(sin(frame_count * 0.01), (-1.0..1.0), (-120.0..120.0))
  ellipse(x, 0, 100, 100)
  ellipse(-x, 0, 100, 100)
  y = map1d(sin(frame_count * 0.01), (-1.0..1.0), (-120.0..120.0))
  ellipse(0, y, 100, 100)
  ellipse(0, -y, 100, 100)  
  # Vertical blur pass
  gaussian_blur.set('horizontalPass', 0)
  filter(gaussian_blur)  
  # Horizontal blur pass
  gaussian_blur.set('horizontalPass', 1)
  filter(gaussian_blur)  
  filter(threshold)  
end


def settings
  size(500, 500, P2D)
end

