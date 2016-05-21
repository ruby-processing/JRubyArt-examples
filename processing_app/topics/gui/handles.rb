attr_reader :handles

def settings
  size(640, 360)
end

def setup
  sketch_title 'Handles'
  num = height / 15
  @handles = []
  hsize = 10
  num.times do |i|
    handles[i] = Handle.new(width / 2, 10 + i * 15, 50 - hsize / 2, 10, self)
  end
end

def draw
  background(153)
  handles.each(&:run)
  fill(0)
  rect(0, 0, width / 2, height)
end

def mouse_released
  handles.each(&:release_event)
end

def over_rect(x, y, width, height)
  return false unless (x..x + width).cover? mouse_x
  return false unless (y..y + height).cover? mouse_y
  true
end

# the class Handle
class Handle
  attr_reader :app, :x, :y, :boxx, :boxy, :otherslocked
  attr_reader :others, :over, :locked, :press, :size, :stretch

  def initialize(ix, iy, il, is, app)
    @app = app
    @x = ix
    @y = iy
    @stretch = il
    @size = is
    @boxx = x + stretch - size / 2
    @boxy = y - size / 2
    @others = app.handles
    @locked = false
    @otherslocked = false
  end

  def update
    @boxx = x + stretch
    @boxy = y - size / 2
    @otherslocked = others.any?(&:locked)
    unless otherslocked
      over_event
      press_event
    end
    return unless press
    @stretch = constrain(mouse_x - width / 2 - size / 2, 0, width / 2 - size - 1)
  end

  def over_event
    @over = over_rect(boxx, boxy, size, size)
  end

  def press_event
    if over && app.mouse_pressed? || locked
      @press = true
      @locked = true
    else
      @press = false
    end
  end

  def release_event
    @locked = false
  end

  def display
    line(x, y, x + stretch, y)
    fill(255)
    stroke(0)
    rect(boxx, boxy, size, size)
    return unless over || press
    line(boxx, boxy, boxx + size, boxy + size)
    line(boxx, boxy + size, boxx + size, boxy)
  end

  def run
    update
    display
  end
end
