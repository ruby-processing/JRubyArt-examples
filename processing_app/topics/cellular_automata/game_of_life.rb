#
# A Processing implementation of Game of Life
# By Martin Prout after Joan Soler-Adillon processing version
#
# Press SPACE BAR to pause and change the cell's values with the mouse
# On pause, click to activate/deactivate cells
# Press R to randomly reset the cells' grid
# Press C to clear the cells' grid
#
# The original Game of Life was created by John Conway in 1970.
#

CELL_SIZE = 5
ALIVE = true
DEAD = false
ALIVE_START = 150
INTERVAL = 100

attr_reader :pause, :cells, :row, :column, :last_time, :alive, :cells_buffer

def setup
  sketch_title 'Game Of Life'
  @pause = false
  # Instantiate arrays
  @row = width / CELL_SIZE
  @column = height / CELL_SIZE
  @cells = Array.new(row) { Array.new(column) { (rand(1000) > ALIVE_START) ? DEAD : ALIVE } }
  @last_time = 0
  @alive = color(100, 255, 100)
  # This stroke will draw the background grid (live cells)
  stroke(48, 100)
end

def draw
  background(0)
  # Draw live cells
  row.times do |x|
    column.times do |y|
      if cells[x][y]
        fill(alive)
        rect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
      end
    end
  end
  # Iterate if timer ticks
  if millis - last_time > INTERVAL
    unless pause
      tick!
      @last_time = millis
    end
  end

  # Create  new cells manually on pause
  if pause && mouse_pressed?
    # # Map and avoid out of bound errors
    over_x = (map1d(mouse_x, (0..width), (0..row))).to_i
    over_x = constrain(over_x, 0, row - 1)
    over_y = (map1d(mouse_y, (0..height), (0..column))).to_i
    over_y = constrain(over_y, 0, column - 1)
    # Check against cells in buffer
    if cells_buffer[over_x][over_y]  # Cell is alive
      cells[over_x][over_y] = DEAD # Kill
      fill(0) # reflect changed status
    else  # Cell is dead
      cells[over_x][over_y] = ALIVE # Make alive
      fill(alive) # Fill alive color
    end

  elsif pause && !mouse_pressed?  # And then save to buffer once mouse goes up
    # Save a copy of cells to buffer (so we can operate on the copy)
    @cells_buffer = clone2d(cells)
  end
end

def settings
  size(960, 640)
  no_smooth
end

def tick!  # When the clock ticks
  # Save cells to buffer (so we operate with one array keeping the other intact)
  @cells_buffer = clone2d(cells)
  # Visit each cell:
  row.times do |x|
    column.times do |y|
      # And visit all the neighbours of each cell
      neighbours = 0 # We'll count the neighbours
      (x - 1..x + 1).each do |xx|
        (y - 1..y + 1).each do |yy|
          # Make sure you are not out of bounds
          next unless [(xx >= 0), (xx < row), (yy >= 0), (yy < column)].all? 
          # Make sure to check against self
          next if [(xx == x), (yy == y)].all? 
          # Check alive neighbours and count them
          neighbours += 1 if cells_buffer[xx][yy]
        end # End of yy loop
      end # End of xx loop
      # We've checked the neighbours: apply rules in one line (only in ruby)!
      cells[x][y] = (cells_buffer[x][y]) ? ((2..3) === neighbours) : (neighbours == 3)
    end # End of y loop
  end # End of x loop
end # End of function

def key_pressed
  case key
  when 'r', 'R'
    # Restart: reinitialization of cells
    @cells = Array.new(row) { Array.new(column) { (rand(1000) > ALIVE_START) ? DEAD : ALIVE } }
  when ' ' # On/off of pause
    @pause = !pause
  when 'c', 'C' # Clear all
    @cells = Array.new(row, Array.new(column, DEAD))
  end
end

def clone2d(array)
  # Marshal.load(Marshal.dump(array)) # alternative ruby method
  array.map(&:clone)
end
