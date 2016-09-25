# After original by Alex Young https://github.com/alexyoung/fire-p5r

# Algorithm:
# 1. Create an indexed palette of red, orange and yellows
# 2. Loop:
# 3.   Draw a random set of colours from the palette at the bottom of the screen
# 4.   Loop through each pixel and average the colour index value around it
# 5.   Reduce the average by a fire intensity factor

# k9 --run fire.rb
load_library :palette

def settings
  size 320, 240
end

def setup
  sketch_title 'Fire'
  frame_rate 30
  @palette = Palette.create_palette
  @fire = []
  @scale = 8
  @width = width / @scale
  @height = height / @scale
  @intensity = 2
end

def draw
  background 0
  update_fire
end

def update_fire
  random_line @height - 1
  (0..@height - 2).each do |y|
    (0..@width).each do |x|
      # Wrap
      left = x.zero? ? fire_data(@width - 1, y) : fire_data(x - 1, y)
      right = (x == @width - 1) ? fire_data(0, y) : fire_data(x + 1, y)
      below = fire_data(x, y + 1)
      # Get the average pixel value
      average = (left.to_i + right.to_i + (below.to_i * 2)) / 4
      # Fade the flames
      average -= @intensity if average > @intensity
      set_fire_data x, y, average
      fill @palette[average]
      stroke @palette[average]
      rect x * @scale, (y + 1) * @scale, @scale, @scale
    end
  end
end

def fire_data(x, y)
  @fire[offset(x, y)]
end

def set_fire_data(x, y, value)
  @fire[offset(x, y)] = value.to_i
end

def random_offset
  rand(0..@palette.size)
end

def random_line(y)
  (0...@width).each do |x|
    @fire[offset(x, y)] = random_offset
  end
end

def offset(x, y)
  (y * @width) + x
end
