load_libraries :balls, :handy
java_import 'org.gicentre.handy.HandyRenderer'
BALL_NUM = 6
attr_reader :handy, :balls

def settings
  size(400, 400)
end

def setup
  sketch_title 'Handy Ball Collision'
  @handy = HandyRenderer.new(self)
  @balls = (0...BALL_NUM).map { |idx| Ball.new(self, idx) }
end

def draw
  background(234, 215, 182)
  fill(0, 255, 0)
  draw_borders(handy)
  balls.each(&:draw)
end

def draw_borders(renderer)
  renderer.rect(20, 20, 360, 20)
  renderer.rect(20, 360, 360, 20)
  renderer.rect(20, 40, 20, 320)
  renderer.rect(360, 40, 20, 320)
end
