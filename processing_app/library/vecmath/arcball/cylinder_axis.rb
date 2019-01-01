# frozen_string_literal: true

INSTRUCTIONS = <<~TEXT
  #######################################################
  1. Mouse Drag to rotate axes
  2. Hold down x, y or z key to clamp rotation in one axis
  3. Mouse wheel to zoom
  Red   = xaxis
  Green = yaxis
  Blue  = zaxis
  #######################################################
TEXT

SIDES = 30
ANGLE = 360 / SIDES
LENGTH = 200
RADIUS = 20

def setup
  sketch_title 'Rotate Axes'
  ArcBall.init self
  puts INSTRUCTIONS
end

def draw
  background(128, 128, 128)
  lights
  no_stroke
  draw_axes
end

def draw_axes
  fill(255, 0, 0)
  draw_x_axis
  fill(0, 255, 0)
  draw_y_axis
  fill(0, 0, 255)
  draw_z_axis
end

def draw_y_axis
  # draw top of the tube
  begin_shape
  (0..SIDES).each do |i|
    y = DegLut.cos(i * ANGLE) * RADIUS
    x = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, 0, y)
  end
  end_shape(CLOSE)
  # draw bottom of the tube
  begin_shape
  (0..SIDES).each do |i|
    y = DegLut.cos(i * ANGLE) * RADIUS
    x = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, LENGTH, y)
  end
  end_shape(CLOSE)
  # draw SIDES
  begin_shape(TRIANGLE_STRIP)
  (0..SIDES).each do |i|
    y = DegLut.cos(i * ANGLE) * RADIUS
    x = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, 0, y)
    vertex(x, LENGTH, y)
  end
  end_shape(CLOSE)
end

def draw_z_axis
  # draw top of the tube
  begin_shape
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(0, x, y)
  end
  end_shape(CLOSE)
  # draw bottom of the tube
  begin_shape
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(LENGTH, x, y)
  end
  end_shape(CLOSE)
  # draw SIDES
  begin_shape(TRIANGLE_STRIP)
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(0, x, y)
    vertex(LENGTH, x, y)
  end
  end_shape(CLOSE)
end

def draw_x_axis
  # draw top of the tube
  begin_shape
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, y, 0)
  end
  end_shape(CLOSE)
  # draw bottom of the tube
  begin_shape
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, y, LENGTH)
  end
  end_shape(CLOSE)
  # draw SIDES
  begin_shape(TRIANGLE_STRIP)
  (0..SIDES).each do |i|
    x = DegLut.cos(i * ANGLE) * RADIUS
    y = DegLut.sin(i * ANGLE) * RADIUS
    vertex(x, y, 0)
    vertex(x, y, LENGTH)
  end
  end_shape(CLOSE)
end

def settings
  size(500, 500, P3D)
end
