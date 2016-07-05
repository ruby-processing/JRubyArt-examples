# Louis Christodoulou (louis -at- louisc.co.uk)
#
# Very quickly thrown together code whilst learning how the
# geomerative library ticks.
#
# Here we take out previous scripts drawing and placing points along an arc and
# complete our initial idea of placing text along the arc.
#
# Full Writeup on the Blog here: http://louisc.co.uk/?p=2686
require 'geomerative'

MESSAGE = 'hello bendy world  >>>'.freeze
SCALE = 3
attr_reader :font, :points

def settings
  size(800, 450)
end

def setup
  # Geomerative
  sketch_title 'Geomerative Text On A Path'
  # From the examples we must always initialise the library using this command
  RG.init(self)
  @points = []
  background(255)
  # We want a dymo labeller style look, replace this font with your choice
  # see data folder for licence
  @font = RFont.new(data_path('Impact Label Reversed.ttf'), 72, RIGHT)
end

def draw
  # Blank Background each frame
  background(0)
  # Create a new RShape each frame
  wave = RShape.new
  # At the moment the wave object is empty, so lets add a curve:
  wave.add_move_to(0 * SCALE, 100 * SCALE)
  wave.add_bezier_to(
    0 * SCALE,
    100 * SCALE,
    50 * SCALE,
    25 * SCALE,
    100 * SCALE,
    100 * SCALE
  )
  wave.add_bezier_to(
    100 * SCALE,
    100 * SCALE,
    150 * SCALE,
    175 * SCALE,
    200 * SCALE,
    100 * SCALE
  )
  translate(100, -80)
  # draw our wave
  no_fill
  stroke(255, 0, 0)
  stroke_weight(60)
  stroke_cap(PROJECT)
  wave.draw
  stroke_cap(ROUND)
  # Collect some points along the curve
  RG.set_polygonizer(RCommand::UNIFORMLENGTH)
  RG.set_polygonizer_length(35)
  points = wave.get_points
  index = 0 # Letter index within the string message
  # loop through and place a letter at each point
  MESSAGE.each_char do |letter|
    center = RCommand.new(points[index], points[index + 1]).get_center
    fill(255)
    no_stroke
    push_matrix
    translate(center.x, center.y)
    rotate(get_angle(points[index], points[index + 1]))
    translate(5, 20)
    font.draw(letter)
    pop_matrix
    index += 1
  end
end

# Simple function to calculate the angle between two points
def get_angle(p1, p2)
  atan2(p2.y - p1.y, p2.x - p1.x)
end
