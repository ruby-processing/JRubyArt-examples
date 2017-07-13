
require 'toxiclibs'

SWATCH_HEIGHT = 40.0
SWATCH_WIDTH = 5.0
SWATCH_GAP = 1

MAX_SIZE = 150.0
NUM_DISCS = 300
attr_reader :show_discs

def settings
  size(1024, 768)
  # smooth
end

def setup
  sketch_title 'Color Theme'
  @show_discs = true
  noise_detail(2)
  no_loop
end

def draw
  # first define our new theme
  t = Toxi::ColorTheme.new('test')
  # add different color options, each with their own weight
  t.add_range('soft ivory', 0.5)
  t.add_range('intense goldenrod', 0.25)
  t.add_range('warm saddlebrown', 0.15)
  t.add_range('fresh teal', 0.05)
  t.add_range('bright yellowgreen', 0.05)
  # now add another rand hue which is using only bright shades
  t.add_range(Toxi::ColorRange::BRIGHT, TColor.new_random, rand(0.02..0.05))
  # use the TColor theme to create a list of 160 Colors
  list = t.get_colors(160)
  if show_discs
    background(list.get_lightest.toARGB)
    discs(list)
  else
    background(0)
    yoff = 32
    list.sort_by_distance(false)
    swatches(list, 32, yoff)
    yoff += SWATCH_HEIGHT + 10
    list.sort_by_criteria(Toxi::AccessCriteria::LUMINANCE, false)
    swatches(list, 32, yoff)
    yoff += SWATCH_HEIGHT + 10
    list.sort_by_criteria(Toxi::AccessCriteria::BRIGHTNESS, false)
    swatches(list, 32, yoff)
    yoff += SWATCH_HEIGHT + 10
    list.sort_by_criteria(Toxi::AccessCriteria::SATURATION, false)
    swatches(list, 32, yoff)
    yoff += SWATCH_HEIGHT + 10
    list.sort_by_criteria(Toxi::AccessCriteria::HUE, false)
    swatches(list, 32, yoff)
    yoff += SWATCH_HEIGHT + 10
    list.sort_by_proximity_to(Toxi::NamedColor::WHITE, RGBDistanceProxy.new, false)
    swatches(list, 32, yoff)
  end
  # save_frame(format('theme-%s%s', timestamp, '_##.png'))
end

def timestamp
  Time.now.strftime('%Y%d%m_%H%M%S')
end

def key_pressed
  @show_discs = !show_discs if key == ' '
  redraw
end

def swatches(sorted, x, y)
  no_stroke
  colors = sorted.toARGBArray.to_a
  colors.each do |c|
    fill(c)
    rect(x, y, SWATCH_WIDTH, SWATCH_HEIGHT)
    x += SWATCH_WIDTH + SWATCH_GAP
  end
end

def discs(list)
  no_stroke
  colors = list.toARGBArray.to_a
  colors.shuffle.each do |c|
    fill(c, rand(125.0..255)) # random transparency
    r = rand(MAX_SIZE)
    ellipse(rand(width), rand(height), r, r)
  end
end
