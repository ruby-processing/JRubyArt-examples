# Divan Spectrum 2
load_library 'svg'
include_package 'processing.svg'

def settings
  size(500, 500)
  no_smooth
end

def setup
  sketch_title 'SVG Output'
  begin_record(SVG, data_path('output.svg'))
  no_stroke
  fill(color('#DA9AAD')) # Sedona
  ellipse(width / 2, height / 2, width, height)
  fill(color('#4688B5')) # Cyan
  ellipse(width / 2, height / 2, width / 2, height / 2)
  end_record
  exit
end
