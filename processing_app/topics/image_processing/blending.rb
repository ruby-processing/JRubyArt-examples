#
# Blending
# by Andres Colubri.
#
# Images can be blended using one of the 10 blending modes
# (currently available only in P2D and P3).
# Click to go to cycle through the modes.
#

# NOTE: THIS EXAMPLE IS IN PROGRESS -- REAS

attr_reader :img1, :img2, :pic_alpha, :name, :sel_mode

def setup
  sketch_title 'Blending'
  @img1 = load_image('layer1.jpg')
  @img2 = load_image('layer2.jpg')
  @name = 'REPLACE'
  noStroke
  @sel_mode = REPLACE
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
  text(name, 10, 15)
end

def mouse_pressed
  case @sel_mode
  when REPLACE
    @sel_mode = BLEND
    @name = 'BLEND'
  when BLEND
    @sel_mode = ADD
    @name = 'ADD'
  when ADD
    @sel_mode = SUBTRACT
    @name = 'SUBTRACT'
  when SUBTRACT
    @sel_mode = LIGHTEST
    @name = 'LIGHTEST'
  when LIGHTEST
    @sel_mode = DARKEST
    @name = 'DARKEST'
  when DARKEST
    @sel_mode = DIFFERENCE
    @name = 'DIFFERENCE'
  when DIFFERENCE
    @sel_mode = EXCLUSION
    @name = 'EXCLUSION'
  when EXCLUSION
    @sel_mode = MULTIPLY
    @name = 'MULTIPLY'
  when MULTIPLY
    @sel_mode = SCREEN
    @name = 'SCREEN'
  when SCREEN
    @sel_mode = REPLACE
    @name = 'REPLACE'
  end
end

def mouse_dragged
  return unless height - 50 < mouse_y
  @pic_alpha = (map1d(mouse_x, (0..width), (0..255))).to_i
end

def settings
  size(640, 360)
end

