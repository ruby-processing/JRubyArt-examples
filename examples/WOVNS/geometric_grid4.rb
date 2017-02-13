# Divan Quality, Pastel 2 Palette
PALETTE = %w(#D1D2EA #BFCDE5 #ABC1E5 #EEC3C3 #FFE4F3 #FFEEF8).freeze
STEP = 133

def settings
  size(2400, 6372) # 13.5" x 36", 177 DPI
  no_smooth
end

attr_reader :couluers

def setup
  sketch_title 'Geometric Grid'
  @couluers = web_to_color_array(PALETTE)
  background(color('#6984B8')) # Buscabulla
  no_stroke
  w = width / 18
  h = height / 48
  grid(width, height, STEP, STEP - 1) do |col, row|
    fill(couluers[(row * 1 / 132).to_i % couluers.length])
    rect(col + w / 8, row + h / 8, w * 3 / 4, h * 3 / 4)
  end
  save(data_path('grid.png'))
end
