java_import 'processing.core.PFont'

attr_reader :sans, :serif, :sans_font, :serif_font

def settings
  size 800, 200
end

def setup
  sketch_title 'System Fonts Explorer'
  sans_fonts = PFont.list.select { |f| f =~ /Sans/i }
  serif_fonts = PFont.list.select { |f| f =~ /Serif/i }
  @sans = sans_fonts[0]
  @serif = serif_fonts.sample
  @sans_font = create_font(sans, 40, true)
  @serif_font = create_font(serif, 40, true)
  puts sans_fonts
  puts serif_fonts
end

def draw
  background 200
  fill(0)
  text_font(sans_font)
  text_align(CENTER, CENTER)
  text(sans, width / 2, (height / 2) - 30)
  text_font(serif_font)
  text(serif, width / 2, (height / 2) + 30)
  no_loop
end
