# frozen_string_literal: true

attr_reader :img

def settings
  size(1280, 640, P2D)
end

def setup
  sketch_title 'Noise Add'
  blend_mode(ADD)
  background(0)
  puts('Image takes time to develop be patient...')
end

def draw
  sc = 0.01 / (1 + frameCount / 30)
  img = create_image(width, height, RGB)
  img.load_pixels
  grid(width, height) do |x, y|
    nse = noise(x * sc, y * sc, frame_count * 0.02)
    img.pixels[x + y * width] = nse > 0.6 ? color(4, 2, 1) : color(0)
  end
  img.update_pixels
  image(img, 0, 0)
end

def key_pressed
  return unless key == 's'

  save_frame
end
