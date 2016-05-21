# Request Image
# by Ira Greenberg.
# From Processing for Flash Developers, Friends of ED, 2009.
#
# Shows how to use the request_image() function.
# The request_image() function loads images on a separate thread so that
# the sketch does not freeze while they load.  
# These images are small for a quick download, but try it with your own huge 
# images to get the full effect.
#
# See how to pad a number string in ruby using 'rjust'

attr_reader :imgs

def setup
  sketch_title 'Request Image'
  @imgs = []
  # Load images asynchronously, kind of pointless with this few small images
  10.times do |i|
    imgs << request_image(format('PT_anim%s.gif', i.to_s.rjust(4, '0')))
  end
end

def draw
  background 0
  # put pre-load animation here?
  # When all images are loaded draw them to the screen
  return unless all_loaded?
  imgs.each_with_index do |img, i|
    image(img, width / imgs.length * i, 0, width / imgs.length, height)
  end
end

# Return true when all images are loaded 
def all_loaded?
  imgs.length == 10
end

def settings
  size 1290, 120
end
