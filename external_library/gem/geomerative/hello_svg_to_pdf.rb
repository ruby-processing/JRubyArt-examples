load_library :pdf
require 'geomerative'

attr_reader :grp, :pdf

def settings
  size(400, 400)
  smooth
end

def setup
  sketch_title 'SVG to PDF sketch'
  RG.init(self)
  @grp = RG.load_shape(data_path('bot1.svg'))
  @pdf = create_graphics(width, height, PDF, data_path('bot1.pdf'))
end

def draw
  background(255)
  grp.draw
  pdf.begin_draw
  pdf.background(255)
  grp.draw(pdf)
  pdf.dispose
  pdf.end_draw
end
