# Blending
# by Andres Colubri. Somewhat refactored for JRubyArt by Martin Prout could be
# much better in java if PConstants were enums (we use a ruby hash here)
# Images can be blended using one of the 10 blending modes
# (currently available only in P2D and P3).
# Click to go to cycle through the modes.
#

# NOTE: THIS EXAMPLE IS IN PROGRESS -- REAS

attr_reader :img1, :img2, :pic_alpha, :sel_mode, :idx
# avoid the lengthy if/else chain of the original by using array and hash
NAMES = %w[
  REPLACE BLEND ADD SUBTRACT LIGHTEST DARKEST DIFFERENCE EXCLUSION MULTIPLY SCREEN
].freeze
VALUES = [
  REPLACE, BLEND, ADD, SUBTRACT, LIGHTEST, DARKEST, DIFFERENCE, EXCLUSION, MULTIPLY
]
FILTERS = VALUES.zip(NAMES).to_h # avoids the lengthy if/else chain of original

def setup
  sketch_title 'Blending'
  @img1 = load_image(data_path('layer1.jpg'))
  @img2 = load_image(data_path('layer2.jpg'))
  noStroke
  @idx = -1
  @sel_mode = VALUES.first
end

def draw
  @pic_alpha = (map1d(mouse_x, (0..width), (0..255))).to_i
  background(0)
  tint(255, 255)
  image(img1, 0, 0)
  blend_mode(sel_mode)
  tint(255, pic_alpha)
  image(img2, 0, 0)
  blend_mode(REPLACE)
  fill(255)
  rect(0, 0, 94, 22)
  fill(0)
  text(FILTERS.fetch(sel_mode, 'REPLACE'), 10, 15)
end

def mouse_pressed
  @idx = (idx == VALUES.length) ? 0 : idx + 1
  @sel_mode = VALUES[idx]
end

def mouse_dragged
  return unless height - 50 < mouse_y
  @pic_alpha = (map1d(mouse_x, (0..width), (0..255))).to_i
end

def settings
  size(640, 360, P2D)
end
