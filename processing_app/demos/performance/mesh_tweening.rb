attr_reader :d, :sh

def settings
  size(640, 360, P3D)
end

def setup
  sketch_title 'Mesh Tweening'
  @sh = load_shader('frag.glsl', 'vert.glsl')
  @d = 10
  shader(sh)
  no_stroke
end

def draw
  background(255)
  sh.set('tween', norm_strict(mouse_x, 0, width))
  translate(width / 2, height / 2, 0)
  rotate_x(frame_count * 0.01)
  rotate_y(frame_count * 0.01)
  fill(150)
  begin_shape(QUADS)
  (-500..500).step(d) do |x|
    (-500..500).step(d) do |y|
      fill(255 * noise(x, y))
      attrib_position('tweened', x, y, 100 * noise(x, y))
      vertex(x, y, 0)
      fill(255 * noise(x + d, y))
      attrib_position('tweened', x + d, y, 100 * noise(x + d, y))
      vertex(x + d, y, 0)
      fill(255 * noise(x + d, y + d))
      attrib_position('tweened', x + d, y + d, 100 * noise(x + d, y + d))
      vertex(x + d, y + d, 0)
      fill(255 * noise(x, y + d))
      attrib_position('tweened', x, y + d, 100 * noise(x, y + d))
      vertex(x, y + d, 0)
    end
  end
  end_shape
end
