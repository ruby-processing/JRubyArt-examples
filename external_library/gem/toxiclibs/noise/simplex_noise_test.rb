require 'toxiclibs'
# Test and SimplexNoise Karsten Schmidt

attr_reader :noise_dimension, :noise_offset

NS = 0.06 # (try from 0.005 to 0.5)
KEYS = %w[1 2 3 4].freeze
def settings
  size 300, 300, P2D
end

def setup
  sketch_title 'Simplex Noise Test'
  @noise_dimension = KEYS[0]
  @noise_offset = 100
  load_pixels
end

def draw
  background 0
  (0...width).each do |i|
    (0...height).each do |j|
      noise_val = 0
      case(noise_dimension)
      when KEYS[0]
        noise_val = Toxi::SimplexNoise.noise(i * NS + noise_offset, 0)
      when KEYS[1]
        noise_val = Toxi::SimplexNoise.noise(i * NS + noise_offset, j * NS + noise_offset)
      when KEYS[2]
        noise_val = Toxi::SimplexNoise.noise(i * NS + noise_offset, j * NS + noise_offset, frame_count * 0.01)
      when KEYS[3]
        noise_val = Toxi::SimplexNoise.noise(i * NS + noise_offset, j * NS + noise_offset, 0, frame_count * 0.01)
      else
        noise_val = Toxi::SimplexNoise.noise(i * NS + noise_offset, 0)
      end
      c = (noise_val * 127 + 128).to_i
      # Fix required to return a java signed int
      col = Java::Monkstone::ColorUtil.hex_long(c << 16 | c << 8 | c | 0xff000000)
      pixels[j * width + i] = col # this is more efficient than set
    end
  end
  update_pixels
  @noise_offset += NS / 2
end

def key_pressed
  @noise_dimension = key if KEYS.include? key
end
