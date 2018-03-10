# By inheriting from LibraryProxy draw loop is by reflection sketch draw loop
class DeadGrid < LibraryProxy
  include Processing::Proxy
  attr_reader :app, :block_size, :grid, :width, :height

  def initialize(app)
    @app = app
    @block_size = app.block_size
    @width = app.width / block_size - 1
    @height = app.height / block_size - 1
    init_dead_grid(width, height)
  end

  def to_s
    "\nDeadGrid\n".tap do |string|
      string << "-" * width << "\n"
      grid.each do |row|
        string << row.inspect << "\n"
      end
    end
  end

  def init_dead_grid(width, height)
    @grid = (0..width).map do |row|
      (0..height).map { 0 }
    end
  end

  def draw
    stroke(color(255, 255, 255, 125))
    stroke_weight(1)
    app.grid(width, height) do |row, column| # jruby_art convenience method grid
      x = row * block_size
      y = column * block_size
      if (@grid[row][column] != 0)
        if (@grid[row][column] == 1)
          fill(color(255, 0, 0))
        elsif (@grid[row][column] == 2)
          fill(color(120, 200, 50))
        end
        rect(x, y, block_size, block_size)
      end
    end
  end

  def randomize
    app.grid(width, height) do |row, column| # jruby_art convenience method grid
      grid[row][column] = rand(0..1)
    end
  end

  def can_move?(player, distance)
    case player.direction
    when 0 # left
      check_x = player.x - distance
      check_y = player.y
      return !there?(check_x, check_y) unless player.x.zero?
      false
    when 2 # right
      check_x = player.x + distance
      check_y = player.y
      return !there?(check_x, check_y) if player.x < grid.size
      false
    when 1 # up
      check_x = player.x
      check_y = player.y - distance
      return !there?(check_x, check_y) if player.y > 0
      false
    when 3 # down
      check_x = player.x
      check_y = player.y + distance
      return !there?(check_x, check_y) if player.y <= grid.size
      false
    end
  end

  def there?(x, y)
    grid[x][y] != 0
  end
end

# By inheriting from LibraryProxy draw loop is by reflection sketch draw loop
class Block < LibraryProxy
  include Processing::Proxy
  attr_reader :app, :block_size
  attr_accessor :x, :y, :width, :height, :direction

  def initialize(app)
    @app = app
    @block_size = app.block_size
    @x = 7
    @y = 7
    @width = block_size
    @height = block_size
    @direction = 0
  end

  def draw
    fill(color(55, 0, 255))
    rect(@x * block_size, @y * block_size, @width, @height)
  end
end

# figures out which block to highlight on grid when player can't move
class BlockedHandler
  def update(player, deadgrid)
    case player.direction
    when 0
      return unless deadgrid.grid[player.x - 1][player.y] == 1
      deadgrid.grid[player.x - 1][player.y] = 2
    when 1
      return unless deadgrid.grid[player.x][player.y - 1] == 1
      deadgrid.grid[player.x][player.y - 1] = 2
    when 2
      return unless  deadgrid.grid[player.x + 1][player.y] == 1
      deadgrid.grid[player.x + 1][player.y] = 2
    when 3
      return unless  deadgrid.grid[player.x][player.y + 1] == 1
      deadgrid.grid[player.x][player.y + 1] = 2
    end
  end
end
