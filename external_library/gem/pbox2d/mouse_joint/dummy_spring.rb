# dummy_spring.rb by Martin Prout 
# An example of duck-typing in JRubyArt

# This class avoids the tests for null of the vanilla processing version
class DummySpring
  def initialize; end
  def update(_x, _y); end
  def display; end
  # This is the key function where
  # we attach the spring to an x,y location
  # and the box object's location
  # @param x (will be mouse_x)
  # @param y (will be mouse_y)
  # @param box Box
  # @return new bound Spring
  def bind(x, y, box)
    spring = Spring.new
    spring.bind(x, y, box)
    spring
  end

  def destroy; end
end
