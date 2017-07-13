# Talma Quality, Eden 20 Quality
PALETTE = %w( #C9E0F6 #BAE1D5 #C9E0F6 #BAE1D5 #C9E0F6 #BAE1D5).freeze

def settings
  size(3984, 3000) # 46-48" x 36", 84 DPI
  no_smooth
end

def setup
  background(color('#FEFFF3')) # Pale
  stroke_weight(16) # draw lines 16 pixels thick
  no_fill
  colors = web_to_color_array(PALETTE)
  grid(20, colors.length) do |row, i|
    stroke(colors[i])
    x = -i * 20
    y = row * 500 - i * 20
    begin_shape
    while (x < width)
      vertex(x, y)
      x += 600
      y += 130
      vertex(x, y)
      x += 130
      y -= 200
      vertex(x, y)
    end
    end_shape
  end
  save(data_path('wave.png'))
end
