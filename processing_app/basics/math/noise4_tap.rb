

Coord = Struct.new(:mx, :my, :mz, :az, :al)


attr_reader :half_w, :half_h, :radius, :spin_x, :spin, :coords

PHI = ((1.0 + Math.sqrt(5)) / 2.0 - 1) * TWO_PI # Fibonacci distribution

def settings
  size(480, 480, P3D)
end

def setup
  sketch_title '4D Simplex Noise Test'
  background(0)
  stroke(255)
  fill(32, 255, 64)
  @half_w = width * 0.5
  @half_h = height * 0.5
  @radius = height * 0.4
  @spin_x = 0.0
  @spin = 0.0
  @coords = (0..2_000).map do |i|
    inc = Math.asin(i / 1_000.0 - 1.0) # inclination
    az = PHI * i # azimuth
    # Too lazy to do this the right way... precalculating both the angles and the coordinates
    Coord.new.tap do |coord|
      push_matrix
      rotate_y(az)
      rotate_z(inc)
      translate(radius, 0, 0)
      coord.mx = model_x(0, 0, 0) * 0.007
      coord.my = model_y(0, 0, 0) * 0.007
      coord.mz = model_z(0, 0, 0) * 0.007
      coord.az = az
      coord.al = inc
      pop_matrix
    end
  end
end

def draw
  background(0)
  @spin -= (mouse_x - pmouse_x) * 0.0001 if mouse_pressed?
  @spin_x += spin
  @spin *= 0.98
  push_matrix
  translate(half_w, half_h, -0)
  rotate_y(-spin_x)
  coords.each do |ci|
    push_matrix
    rotate_y(ci.az)
    rotate_z(ci.al)
    translate(radius, 0, 0)
    dst = (modelZ(0, 0, 0) + half_h) / 2 + 32
    stroke(dst, dst * 0.5, dst * 0.25)
    #  4D Simplex noise(x, y, z, time)
    ang = noise(ci.mx, ci.my, ci.mz, frame_count * 0.007) * TWO_PI
    rotate_x(ang)
    line(0, 0, 0, 0, 15, 0)
    translate(0, 15, 0)
    rotate_x(-10)
    line(0, 0, 0, 0, 4, 0)
    rotate_x(20)
    line(0, 0, 0, 0, 4, 0)
    pop_matrix
  end
  pop_matrix
end
