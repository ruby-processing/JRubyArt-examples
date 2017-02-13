# Talma Quality, Spectrum 19 Palette
GRID = 7 # 1/12"

def settings
  size(3984, 3000)
  no_smooth
end

def setup
  sketch_title 'Random gaussian'
  background(color('#8B8795')) # Suva
  no_stroke
  fill(color('#302D32')) # Matte Black
  0.step(by: GRID, to: width) do |x|
    # threshold based on a gaussian function (bell curve) that gives
    # a number between 1 in the middle of the screen and 0 at the left
    # and right edges. the 8.0 adjusts the width of the bell, i.e.
    # how quickly the value drops to 0 as you move towards the edges of
    # the screen.
    threshold = Math.exp(-8.0 * (0.5 - (x.to_f / width)) * (0.5 - (x.to_f / width)))
    0.step(by: GRID, to: height) do |y|
      # generate a random number between 0 and 1 and compare it to the
      # threshold. if it's less than the threshold, draw a small square.
      rect(x, y, GRID, GRID) if (rand < threshold)
    end
  end
  save(data_path('gaussian.png'))
end
