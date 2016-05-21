#
# Spore 1
# by Mike Davis.
#
# A short program for alife experiments. Click in the window to restart.
# Each cell is represented by a pixel on the display as well as an entry in
# the array 'cells'. Each cell has a run method, which performs actions
# based on the cell's surroundings.  Cells run one at a time (to avoid conflicts
# like wanting to move to the same space) and in random order.
#
load_library :simple_cell

attr_reader :cells, :black, :spore_colour

MAX_CELLS = 6_700

# set lower for smoother animation, higher for faster simulation
RUNS_PER_LOOP = 10_000

def setup
  sketch_title 'Spore1'
  frame_rate(24)
  @black = color(0, 0, 0)
  @spore_colour = color(172, 255, 128)
  reset!
end

def reset!
  clear_screen
  seed
end

def seed
  @cells = []
  # Add cells at random places
  MAX_CELLS.times do
    cx = rand(0...width)
    cy = rand(0...height)
    if getpix(cx, cy) == black
      setpix(cx, cy, spore_colour)
      cells << Cell.new(self, cx, cy)
    end
  end
end

def draw
  # Run cells in random order
  RUNS_PER_LOOP.times do
    cells.sample.run
  end
end

def settings
  size(640, 360)
end

def clear_screen
  background(0)
end

def setpix(x, y, c)
  x += width while x < 0
  x -= width while x > (width - 1)
  y += height while y < 0
  y -= height while y > (height - 1)
  set(x, y, c)
end

def getpix(x, y)
  x += width while x < 0
  x -= width while x > (width - 1)
  y += height while y < 0
  y -= height while y > (height - 1)
  get(x, y)
end

def mouse_pressed
  reset!
end
