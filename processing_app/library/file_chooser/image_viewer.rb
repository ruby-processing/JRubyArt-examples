load_library :file_chooser
attr_reader :img
field_accessor :surface
###########
# Example file chooser (in this case an image file chooser).
# We delay setting size of sketch until we know image size, probably
# would not work vanilla processing. Note we can wrap much code in the
# file_chooser block, no need for reflection. As with selectInput vanilla
# processing.
###########

def setup
  sketch_title 'File Chooser'
  surface.set_resizable(true)
  file_chooser do |fc|
    fc.set_filter "Image Files",  [".png", ".jpg"] # easily customizable chooser
    @img = load_image(fc.display)                  # fc.display returns a path String
  end
end

def draw
  background img                                  # img must be same size as sketch
end

def settings
  size 100, 100, P2D
end
