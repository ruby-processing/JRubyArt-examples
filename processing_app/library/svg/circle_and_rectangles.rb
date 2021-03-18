# After a sketch by Marc Edwards at Bjango
# https:#github.com/bjango/Processing-SVG-experiments

load_library :svg

def settings
  size(250, 250)                        # Set up a 250×250 canvas.
end

def setup
  sketch_title 'Simple Example'
  begin_record(SVG, data_path('simple.svg')) # Start recording drawing operations to this file.
  no_loop                                   # Only run draw once.
end

def draw
  no_stroke                      # Turn off the border on objects we’re about to draw.
  fill(color('#4bbcf6'))          # Set the fill colour to light blue.
  rect(50, 50, 100, 100)         # Draw a rectangle on the canvas and to the SVG file.
  fill(color('#5721a5'))         # Set the fill colour to purple.
  ellipse(150, 150, 100, 100)    # Draw a circle on the canvas and to the SVG file.
  end_record                     # Save and close the SVG file recording.
end
