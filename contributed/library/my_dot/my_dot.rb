Vect = Struct.new(:x, :y)

class MyDot
  include Processing::Proxy
  attr_reader :location, :position, :theta, :col, :dir, :start_sz

  def initialize(location, start_sz, col, angle)
    @location = location
    @start_sz = start_sz
    @col = col
    @theta = angle
    @position = Vect.new(rand(-20..20), rand(-20..20))
    @dir = (rand > 0.5) ? -1 : 1
    @theta = angle
  end

  def display
    fill(col, 200)
    push_matrix
    translate(location.x, location.y)
    rotate(theta)
    sz = map1d(sin(theta), -1..1, 5..start_sz * 4)
    rect(position.x, position.y, sz, sz, sz / 4)
    pop_matrix
    @theta += 0.0523 * dir
  end

end
