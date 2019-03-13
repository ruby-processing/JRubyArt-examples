
WIDTH = 1_400
HEIGHT = 1_100
SCL = 30
attr_reader :terrain, :rows, :columns, :mover

def settings
  size 800, 800, P3D
end

def setup
  sketch_title 'Terrain'
  @columns = WIDTH / SCL
  @rows = HEIGHT / SCL
  @terrain = {}
  @mover = 0
end

def draw
  background 0
  @mover -= 0.1
  yoff = mover
  (0..rows).each do |y|
    xoff = 0
    (0..columns).each do |x|
      terrain[hash_key(x, y)] = Vec3D.new(x * SCL, y * SCL, map1d(noise(xoff, yoff), 0..1.0, -65..65))
      xoff += 0.2
    end
    yoff += 0.2
  end
  no_fill
  stroke 235, 69, 129
  translate width / 2, height / 2
  rotate_x PI / 3
  translate(-WIDTH / 2, -HEIGHT / 2)
  (0...rows).each do |y|
    begin_shape(TRIANGLE_STRIP)
    (0..columns).each do |x|
      terrain[hash_key(x, y)].to_vertex(renderer)
      terrain[hash_key(x, y.succ)].to_vertex(renderer)
    end
    end_shape
  end
end

private

# HACK should be safe here
def hash_key(x, y)
  WIDTH * y + x
end

def renderer
  @renderer ||= GfxRender.new(self.g)
end
