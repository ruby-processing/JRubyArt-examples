# Taken from processing discussion board, a little sketch by Amnon Owed
# Illustrates use of offscreen image, texture sampling, mouse_pressed?,
# load_pixels, displayWidth and displayHeight (do not snake case the last two)

SCALE = 5  
COLOR_RANGE = 16_581_375 # 255 * 255 * 255

attr_reader :grid
 
def setup
  @grid = create_image(width / SCALE, height / SCALE, RGB)
  g.texture_sampling(2) # 2 = POINT mode sampling
end
 
def draw
  unless mouse_pressed?
    grid.load_pixels
    grid.pixels.length.times do |i|
      grid.pixels[i] = rand(COLOR_RANGE)
    end
    grid.update_pixels
  end
  image(grid, 0, 0, width, height)
end

def settings
  full_screen P2D
end
