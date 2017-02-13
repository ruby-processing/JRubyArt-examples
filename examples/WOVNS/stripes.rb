# Talma Quality, Spectrum 2 Palette
PALETTE = %w(#D5C9D9 #B83D4E #95577E #A884A1).freeze
COULEURS = %i(pink_pearl geranium orchid lilac).freeze
STRPE = 500

def settings
  size(3984, 3000) # dimensions in pixels (corresponds to 46-48" x 36" at 84 DPI)
  no_smooth
end

def setup
  sketch_title 'Horizontal Stripes'
  web = COULEURS.zip(web_to_color_array(PALETTE)).to_h
  background(web[:pink_pearl]) # draw the background
  no_stroke # don't draw outlines around shapes

  # Draw stripes at y = 0, 500, 1000, 1500, 2000, and 2500.
  # Note that we're using the special variable "height", which is the height
  # of the canvas (3000 pixels as specified in the call to size() above).
  0.step(by: STRPE, to: height) do |y|
    # Draw the first stripe using the rect() function.
    # Note that we're using the special variable "width", the analogue of
    # "height". Its value is 3984.
    fill(web[:geranium]) # set the color of the first rectangle
    rect(0, y, width, 84) # corner at (0, y). full width, 84 pixels high.
    # Draw two shorter stripes.
    fill(web[:orchid])
    rect(0, y + 84 + 21, width, 10) # start 21 pixels (1/4") below the first stripe
    fill(web[:lilac])
    rect(0, y + 84 + 42, width, 10) # start 42 pixels (1/2") below the first stripe
  end
  save(data_path('stripes.png')) # save the output to data folder
end
