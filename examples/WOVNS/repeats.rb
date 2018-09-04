# Divan Quality, Spectrum 19 Palette
# the size of the generated image (should match the WOVNS quality)
WIDTH = 2400
HEIGHT = 6372
PALETTE = %w[#050505 #B83D4E #FFFFFF].freeze
COULEURS = %i[petrol geranium white].freeze
STRPE = 500

# how many repeats of the generated image to show on-screen
X_REPEATS = 4 # match the number of horizontal repeats in the Divan quality
Y_REPEATS = 2 # show two yards vertically

# scale down the on-screen display by this much
SCALE = 18

attr_reader :web

def settings
  size(WIDTH / SCALE * X_REPEATS, HEIGHT / SCALE * Y_REPEATS)
  no_smooth
end

def setup
  sketch_title 'Repeats'
  @web = COULEURS.zip(web_to_color_array(PALETTE)).to_h
  pg = create_graphics(WIDTH, HEIGHT)
  pg.no_smooth
  pg.begin_draw
  background(web[:petrol])
  pg.background(web[:petrol])
  # draw to the saved image
  draw_one(pg)
  stroke(web[:white])
  line(width / X_REPEATS, 0, width / X_REPEATS, height / Y_REPEATS)
  line(0, height / Y_REPEATS, width / X_REPEATS, height / Y_REPEATS)
  grid(X_REPEATS, Y_REPEATS) do |i, j|
    push_matrix # save coordinate system
    # translate to the current repeat
    translate(i * width / X_REPEATS, j * height / Y_REPEATS)
    clip(0, 0, width / X_REPEATS + 1, height / Y_REPEATS + 1)
    scale(1.0 / SCALE, 1.0 / SCALE)
    # draw to the screen
    draw_one(g)
    pop_matrix # restore coordinate system
  end
  pg.end_draw
  pg.save(data_path('repeat.png'))
end

# Draw one division of one repeat.
def draw_one(graphics)
  graphics.stroke_weight(177)
  graphics.stroke(web[:geranium])
  graphics.line(0, 0, 2400, 6372)
  graphics.line(2400, 0, 0, 6372)
end
