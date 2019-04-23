require 'toxiclibs'

SWATCH_HEIGHT = 40.0
SWATCH_WIDTH = 5.0
SWATCH_GAP = 1
MAX_SIZE = 150.0
NUM_DISCS = 300
attr_reader :show_discs, :list, :increment

def settings
  size(1024, 768)
  # smooth
end

def setup
  sketch_title 'Color Theme'
  @show_discs = true
  noise_detail(2)
  no_loop
  @increment = 0
end

def draw
  # first define our new theme
  theme = Toxi::ColorTheme.new('test')
  # add different color options, each with their own weight
  theme.add_range('soft ivory', 0.5)
  theme.add_range('intense goldenrod', 0.25)
  theme.add_range('warm saddlebrown', 0.15)
  theme.add_range('fresh teal', 0.05)
  theme.add_range('bright yellowgreen', 0.05)
  # now add another rand hue which is using only bright shades
  theme.add_range(Toxi::ColorRange::BRIGHT, TColor.new_random, rand(0.02..0.05))
  # use the TColor theme to create a list of 160 Colors
  @list = theme.get_colors(160)
  if show_discs
    background(list.get_lightest.toARGB)
    discs(list)
  else
    background(0)
    display_swatch(list.sort_by_distance(false))
    display_swatch(
      list.sort_by_criteria(Toxi::AccessCriteria::LUMINANCE, false)
    )
    list.sort_by_criteria(Toxi::AccessCriteria::BRIGHTNESS, false)
    display_swatch(
      list.sort_by_criteria(Toxi::AccessCriteria::SATURATION, false)
    )
    display_swatch(list.sort_by_criteria(Toxi::AccessCriteria::HUE, false))
    display_swatch(
      list.sort_by_proximity_to(
        Toxi::NamedColor::WHITE, Toxi::RGBDistanceProxy.new, false
      )
    )
  end
end

def display_swatch(list)
  swatches(list, 32, 32 + (SWATCH_HEIGHT + 10) * increment)
  @increment += 1
end

def timestamp
  Time.now.strftime('%Y%d%m_%H%M%S')
end

def key_pressed
  theme_format = 'theme-%s%s'
  case key
  when 's', 'S'
    save_frame(data_path(format(theme_format, timestamp, '_##.png')))
    redraw
  when 'd', 'D'
    @show_discs = !show_discs
    @increment = 0
    redraw
  when 'p', 'P'
    File.open(data_path('color_theme.rb'), 'w') do |file|
      file.write("# Test Theme\n")
      file.write(list.to_ruby_string)
    end
  end
end

def swatches(sorted, x, y)
  no_stroke
  colors = sorted.toARGBArray.to_a
  colors.each do |col|
    fill(col)
    rect(x, y, SWATCH_WIDTH, SWATCH_HEIGHT)
    x += SWATCH_WIDTH + SWATCH_GAP
  end
end

def discs(list)
  no_stroke
  colors = list.toARGBArray.to_a
  colors.shuffle.each do |col|
    fill(col, rand(125.0..255)) # random transparency
    radius = rand(MAX_SIZE)
    ellipse(rand(width), rand(height), radius, radius)
  end
end
