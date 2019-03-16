# Ball of Confusion Sketch see original by Ben Notiaranni
# http://lazydog-bookfragments.blogspot.com/2008/12/orb-code.html
NUMBER_OF_HAIRS = 10_000
BODY_R = 25.0
MIN_HAIR_LENGTH = 24.0
SHORT_HAIR_LENGTH = 30.0
LONG_HAIR_LENGTH = 10.0
LONG_HAIR_MAX_LENGTH = 30.0
LONG_DENDRITE_LENGTH = 20.0
LONG_DENDRITE_MAX_LENGTH = 60.0

attr_reader :rotation_history, :g_frame, :g_lights, :ball_theta, :ball_phi
attr_reader :camera_r, :camera_theta, :camera_phi, :graphics, :cr

def key_pressed
  return unless key == 'l'
  @g_lights = !g_lights
end

def settings
  size(800, 600, P3D)
  smooth
end

def setup
  sketch_title 'Ball of Confusion'
  colorMode(RGB, 1.0)
  background(0.0)
  @rotation_history = RotationHistory.new(200)
  @g_lights = true
  @g_frame = 0
  @camera_r = 130.0
  @camera_phi = PI / 4
  @camera_theta = 0.0
  @ball_theta = 0
  @ball_phi = 0
  @graphics = self.g
  # blend_mode(DIFFERENCE)
end

def draw
  @camera_r = 180.0 + (sin(g_frame/50.0) + cos(g_frame / 57)) * 25
  @g_frame += 1.0
  @ball_theta += 2.0 * sin(g_frame/53.0)
  @ball_phi += 2.0 * sin(g_frame/83.0)
  rotation_history.push(ball_theta, ball_phi)
  background(0.0)
  camera_spherical(camera_r, camera_phi, -camera_theta)
  random_seed(6)
  @cr = 0.0
  if (g_lights)
    @cr = 1.0
    lights
    x = sin(g_frame / 30.0)
    y = sin(g_frame / 37.0)
    z = sin(g_frame / 43.0)
    directional_light(1.0, 1.0, 1.0, x, y, z)
    directional_light(0.3, 0.3, 0.3, -x, -y, -z)
  else
    @cr = 0.0
    no_lights
  end
  draw_body(BODY_R, cr * 1.0, cr * 0.4, cr * 0.1, 1.0)
  begin_shape
  draw_spikes(30, BODY_R, LONG_HAIR_LENGTH, LONG_HAIR_MAX_LENGTH)
  draw_dendrites(15, BODY_R, LONG_DENDRITE_LENGTH, LONG_DENDRITE_MAX_LENGTH)
  draw_fuzz(10_000, MIN_HAIR_LENGTH, SHORT_HAIR_LENGTH)
  end_shape
  save_frame(data_path'####.png') if frame_count > 100
end

def draw_dendrites(count, br, l1, l2)
  count.times do
    length = rand(l1..l2)
    theta = rand(0.0..360.0)
    phi = rand(0.0..180.0)
    push_matrix
    rotation_history.record(0).draw(graphics)
    draw_patch(br + 0.1, theta, phi, 4.radians, 16)
    pop_matrix
    c1 = color(sin(g_frame / 100.0).abs, sin(g_frame / 123.0).abs, sin(g_frame / 176.0).abs, 1.0)
    c2 = color(sin(g_frame / 57.0).abs, sin(g_frame / 23.0).abs, sin(g_frame / 67.0).abs, 0.0)
    hair = Hair.new(length*2, br, theta + rand, phi + rand, c1, c2, 1.0)
    hair.draw
  end
end

def draw_spikes(count, br, l1, l2)
  count.times do
    theta = rand(0.0..360.0)
    phi = rand(0.0..180.0)
    push_matrix
    rotation_history.record(0).draw(graphics)
    draw_patch(br + 0.1, theta, phi, 4.radians, 16)
    pop_matrix
    length = rand(l1..l2)
    (0..10).each do |j|
      l = (j == 9) ? length : rand(l1..length)
      hair = Hair.new(l, br, theta + rand, phi + rand, color(1.0, 1.0, 1.0, 1.0), color(1.0, 0.4, 0.1, 0.1), 1.0)
      hair.draw
    end
  end
end

def draw_fuzz(count, r1, r2)
  push_matrix
  rotation_history.record(0).draw(graphics)
  begin_shape(LINES)
  count.times do
    theta = rand(0..TWO_PI)
    phi = rand(0..PI)
    x1 = cos(theta) * sin(phi)
    y1 = sin(theta) * sin(phi)
    z1 = cos(phi)
    r = rand(r1..r2)
    c1 = 1.0
    c2 = 1.0 * 0.4
    stroke(c1, c1, c1, 0.5)
    vertex(x1 * r1, y1 * r1, z1 * r1)
    stroke(c2, c2, c2, 0.0)
    vertex(x1 * r, y1 * r, z1 * r)
  end
  end_shape
  pop_matrix
end

def draw_body(r, red, green, blue, alpha)
  no_stroke
  fill(red, green, blue, alpha)
  sphere(r)
end

def camera_spherical(r, phi, theta)
  x = r * cos(theta) * sin(phi)
  y = r * sin(theta) * sin(phi)
  z = r * cos(phi)
  nx = cos(theta) * cos(phi)
  ny = sin(theta) * cos(phi)
  nz = -sin(phi)
  camera(x, y, z, 0.0, 0.0, 0.0, nx, ny, nz)
end

def draw_patch(r, theta, phi, ar, smoothness)
  push_matrix
  rotate(theta, 0.0, 0.0, 1.0)
  rotate(phi, 0.0, 1.0, 0.0)
  begin_shape(TRIANGLE_FAN)
  x = r * sin(ar)
  z = r * cos(ar)
  fill(1.0, 1.0, 1.0, 1.0)
  vertex(0.0, 0.0, r)
  fill(1.0, 0.0, 0.0, 0.0)
  smoothness.times do |i|
    vertex(x * cos(TWO_PI * i / smoothness), x * sin(TWO_PI * i / smoothness), z)
  end
  end_shape

  pop_matrix
end

class Hair
  attr_reader :length, :r, :theta, :phi, :sections
  attr_reader :r1, :g1, :b1, :a1, :r2, :g2, :b2, :a2

  def initialize(length, r, theta, phi, c1, c2, smoothness)
    @length = length
    @r = r
    @theta = theta.radians
    @phi = phi.radians
    @r1 = red(c1)
    @g1 = green(c1)
    @b1 = blue(c1)
    @a1 = alpha(c1)
    @r2 = red(c2)
    @g2 = green(c2)
    @b2 = blue(c2)
    @a2 = alpha(c2)
    @sections = (length / smoothness).round
  end

  def draw
    push_matrix
    begin_shape(LINE_STRIP)
    sections.times do |i|
      dh = i.to_f / sections
      h = r + length * dh
      x = h * cos(@theta) * sin(@phi)
      y = h * sin(@theta) * sin(@phi)
      z = h * cos(@phi)
      theta = rotation_history.record(-i).theta.radians
      phi = rotation_history.record(-i).phi.radians
      x1= x * cos(phi) + z * sin(phi)
      y1 = y
      z1 = -x * sin(phi) + z * cos(phi)
      x = x1 * cos(theta) - y1 * sin(theta)
      y = x1 * sin(theta) + y1 * cos(theta)
      z = z1
      stroke(r1 + (r2 - r1) * dh, g1 + (g2 - g1) * dh, b1 + (b2 - b1) * dh, a1 + (a2 - a1) * dh)
      vertex(x, y, z)
    end
    end_shape
    pop_matrix
  end
end

# Struct to store rotations, with draw(graphics) method to return rotations
Record = Struct.new(:theta, :phi) do
  def draw(gfx)
    gfx.rotate_z(theta)
    gfx.rotate_y(phi)
  end
end

class RotationHistory
  attr_reader :history, :size, :frame

  def initialize(size = 100)
    @history = (0..size).map { Record.new(0, 0) }
    @size = size
    @frame = 0
  end

  def push(theta, phi)
    @frame += 1
    history[frame % size].theta = theta
    history[frame % size].phi = phi
  end

  def record(idx)
    history[(frame + idx).abs % size]
  end
end
