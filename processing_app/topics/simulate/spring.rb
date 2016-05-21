#
# Ported from http://www.processing.org/learning/topics/spring.html
#
# Click, drag, and release the horizontal bar to start the spring.
#
attr_reader :over, :move

def setup
  sketch_title 'Spring'
  rect_mode CORNERS
  no_stroke
  @s_height = 16    # Height
  @left     = 50    # Left position
  @right    = 150   # Right position
  @max      = 100   # Maximum Y value
  @min      = 20    # Minimum Y value
  @over     = false # If mouse over
  @move     = false # If mouse down and over
  # Spring simulation constants
  @mass     = 0.8   # Mass
  @k        = 0.2   # Spring constant
  @d        = 0.92  # Damping
  @rest     = 60    # Rest position

  # Spring simulation variables
  @ps       = 60.0  # Position
  @vs       = 0.0   # Velocity
  @as       = 0     # Acceleration
  @f        = 0     # Force
end

def draw
  background 102
  update_spring
  draw_spring
end

def settings
  size 200, 200
end

def draw_spring
  # Draw base
  fill 0.2
  b_width = 0.5 * @ps + -8
  rect(width / 2 - b_width, @ps + @s_height, width / 2 + b_width, 150)
  # Set color and draw top bar
  (over || move) ? fill(255) : fill(204)
  rect @left, @ps, @right, @ps + @s_height
end

def update_spring
  # Update the spring position
  unless move
    @f = -1 * @k * (@ps - @rest) # f=-ky
    @as = @f / @mass            # Set the acceleration, f=ma == a=f/m
    @vs = @d * (@vs + @as)    # Set the velocity
    @ps += @vs           # Updated position
  end
  @vs = 0.0 if @vs.abs < 0.1
  # Test if mouse is over the top bar
  within_x = (@left..@right).include?(mouse_x)
  within_y = (@ps..@ps + @s_height).include?(mouse_y)
  @over = within_x && within_y
  # Set and constrain the position of top bar
  return unless move
  @ps = mouse_y - @s_height / 2
  @ps = constrain(@ps, @min, @max)
end

def mouse_pressed
  @move = over
end

def mouse_released
  @move = false
end
