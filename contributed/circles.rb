load_library :circle

def settings
  size(800, 600, P2D)
end

def setup
  sketch_title 'Circles'
  color_mode(HSB, 360, 100, 100, 100)
  reset
  ellipse_mode(RADIUS)
end

def draw
  fill(0, 0, 0)
  no_stroke
  reset if (frame_count % 8_000).zero?
  @points.each do |point|
    # change direction sometimes
    point.direction Vec2D.random if rand > 0.96
    point.update
  end

  # set the style of the circle
  @dc = map1d(millis, 0..150_000, 0..360) # slowly changes hue
  stroke((@c + @dc) % 360, 50, 100, 5)
  no_fill

  ## verifies if there is a circle and draw it
  draw_circle @points unless @points.collinear?
end

def draw_circle(pts)
  circumcircle = Circumcircle.new(@points.positions)
  circumcircle.calculate
  center_point = circumcircle.center
  radius = circumcircle.radius
  ellipse(center_point.x, center_point.y, radius, radius)
end

def reset
  @c = rand(360)
  @points = TrianglePoints.new
  3.times { @points << TPoint.new(Vec2D.new(rand(5..width - 5), rand(5..height - 5))) }
  background 0
end
