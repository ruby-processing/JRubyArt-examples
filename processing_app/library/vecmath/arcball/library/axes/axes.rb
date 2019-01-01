# frozen_string_literal: true

java_import 'processing.core.PConstants'
# Three axes as a class
class Axes
  SIDES = 30
  ANGLE = 360 / SIDES
  LENGTH = 200
  RADIUS = 20

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def draw
    app.fill(255, 0, 0)
    draw_x_axis
    app.fill(0, 255, 0)
    draw_y_axis
    app.fill(0, 0, 255)
    draw_z_axis
  end

  def draw_y_axis
    # draw top of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      y = DegLut.cos(i * ANGLE) * RADIUS
      x = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, 0, y)
    end
    app.end_shape(PConstants::CLOSE)
    # draw bottom of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      y = DegLut.cos(i * ANGLE) * RADIUS
      x = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, LENGTH, y)
    end
    app.end_shape(PConstants::CLOSE)
    # draw SIDES
    app.begin_shape(PConstants::TRIANGLE_STRIP)
    (0..SIDES).each do |i|
      y = DegLut.cos(i * ANGLE) * RADIUS
      x = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, 0, y)
      app.vertex(x, LENGTH, y)
    end
    app.end_shape(PConstants::CLOSE)
  end

  def draw_z_axis
    # draw top of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(0, x, y)
    end
    app.end_shape(PConstants::CLOSE)
    # draw bottom of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(LENGTH, x, y)
    end
    app.end_shape(PConstants::CLOSE)
    # draw SIDES
    app.begin_shape(PConstants::TRIANGLE_STRIP)
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(0, x, y)
      app.vertex(LENGTH, x, y)
    end
    app.end_shape(PConstants::CLOSE)
  end

  def draw_x_axis
    # draw top of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, y, 0)
    end
    app.end_shape(PConstants::CLOSE)
    # draw bottom of the tube
    app.begin_shape
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, y, LENGTH)
    end
    app.end_shape(PConstants::CLOSE)
    # draw SIDES
    app.begin_shape(PConstants::TRIANGLE_STRIP)
    (0..SIDES).each do |i|
      x = DegLut.cos(i * ANGLE) * RADIUS
      y = DegLut.sin(i * ANGLE) * RADIUS
      app.vertex(x, y, 0)
      app.vertex(x, y, LENGTH)
    end
    app.end_shape(PConstants::CLOSE)
  end
end
