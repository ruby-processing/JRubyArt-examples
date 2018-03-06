require 'observer'
include Observable
load_libraries :library_proxy, :dead_grid
attr_accessor :deadgrid, :player, :block_size
SPACE = 32

def settings
  size 256, 256
end

def setup
  sketch_title 'Dead Grid Events'
  @block_size = 16
  @deadgrid = DeadGrid.new self
  @player = Block.new self
  puts deadgrid
  add_observer(BlockedHandler.new)
end

def draw
  background 0
  draw_grid_lines
end

def draw_grid_lines
  stroke_weight 1
  stroke 40
  # for each block in deadgrid, draw lines using JRubyArt `grid` utility
  grid(width, height, block_size, block_size) do |x, y|
    line(x, 0, x, height)
    line(0, y, width, y)
  end
end

def key_pressed
  case key_code
  when SPACE
    puts 'Randomize.'
    deadgrid.randomize
    # if grid spawns under player, remove it
    unless deadgrid.grid[player.x][player.y].zero?
      deadgrid.grid[player.x][player.y] = 0
    end
  when LEFT
    player.direction = 0
    return unless player.x > 0
    return player.x = player.x - 1 if deadgrid.can_move?(player, 1)
    changed
    notify_observers(player, deadgrid)
  when RIGHT
    player.direction = 2
    # check bounds
    return unless player.x < deadgrid.width
    return player.x = player.x + 1 if deadgrid.can_move?(player, 1)
    changed
    notify_observers(player, deadgrid)
  when UP
    player.direction = 1
    # check bounds
    return unless player.y > 0
    return player.y = player.y - 1 if deadgrid.can_move?(player, 1)
    changed
    notify_observers(player, deadgrid)
  when DOWN
    player.direction = 3
    return unless player.y < deadgrid.height
    return player.y = player.y + 1 if deadgrid.can_move?(player, 1)
    changed
    notify_observers(player, deadgrid)
  end
end
