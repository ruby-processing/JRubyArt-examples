# PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
#
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
#
load_library :PixelFlow
java_import 'com.thomasdiewald.pixelflow.java.sampling.DwSampling'
attr_reader :shp_samples, :sample_idx

def settings
  size(800, 800, P2D)
  smooth(8)
end

def setup
  sketch_title 'Sampling Fibonacci'
  @sample_idx = 1
  @shp_samples = create_shape(GROUP)
  frame_rate(1_000)
end

def draw
  background(64)
  r = 0.01 * sample_idx**0.5
  angle = sample_idx * DwSampling::GOLDEN_ANGLE_R
  x = r * cos(angle)
  y = r * sin(angle)
  add_shape(Vec2D.new(x, y), 500)
  translate(width / 2, height / 2)
  shape(shp_samples)
  @sample_idx += 1
end

def add_shape(position, scale)
  pos = position * scale
  shp_point = create_shape(POINT, pos.x, pos.y)
  shp_point.set_stroke(color(255))
  shp_point.set_stroke_weight(3)
  shp_samples.add_child(shp_point)
end
