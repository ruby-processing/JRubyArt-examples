# Learning Processing
# Daniel Shiffman
# http://www.learningprocessing.com

# Example 22-2: Polymorphism

# One array of Shapes, in ruby we don't need polymorphism to achieve that,
# this is a JRubyArt port. Introducing the hook method, keyword args and the
# post_initialization hook for flexible inheritance. Important we only
# really need to know 'run' method. Note initialization of color can be
# specified for Circle,defaults to color(rand(255), 100) see shapes/circle.rb.
require_relative 'shapes/square'
require_relative 'shapes/circle.rb'

attr_reader :shps

def setup
  sketch_title 'Polymorphism'
  @shps = []
  30.times do
    if rand < 0.5
      shps << Circle.new(x: 320, y: 180, r: 32, c: color(rand(255), 100))
    else
      shps << Square.new(x: 320, y: 180, r: 32)
    end
  end
end

def draw
  background(255)
  shps.each(&:run)
end

def settings
  size(480, 270)
end
