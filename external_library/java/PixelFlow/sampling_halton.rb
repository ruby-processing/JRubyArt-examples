# PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
#
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
#
load_library :PixelFlow
java_import 'com.thomasdiewald.pixelflow.java.sampling.DwSampling'
attr_reader :shp_samples, :sample_idx, :shp_gizmo

def settings
  size(800, 800, P3D)
  smooth(8)
end

def setup
  sketch_title 'Sampling Halton'
  ArcBall.init(self)
  @sample_idx = 1
  @shp_samples = create_shape(GROUP)
  frame_rate(1_000)
end

def draw
  background(64)
  display_gizmo(500)
  sample = DwSampling::uniformSampleHemisphere_Halton(sample_idx)

  add_shape(Vec3D.new(*sample), 400)
  shape(shp_samples)
  @sample_idx += 1
end

def add_shape(position, scale)
  pos = position * scale
  shp_point = create_shape(POINT, pos.x, pos.y, pos.z)
  shp_point.set_stroke(color(255))
  shp_point.set_stroke_weight(3)
  shp_samples.add_child(shp_point)
end

def display_gizmo(s)
  if(shp_gizmo.nil?)
    stroke_weight(1)
    @shp_gizmo = create_shape
    shp_gizmo.begin_shape(LINES)
    shp_gizmo.stroke(255,0,0)
    shp_gizmo.vertex(0,0,0)
    shp_gizmo.vertex(s,0,0)
    shp_gizmo.stroke(0,255,0)
    shp_gizmo.vertex(0,0,0)
    shp_gizmo.vertex(0,s,0)
    shp_gizmo.stroke(0,0,255)
    shp_gizmo.vertex(0,0,0)
    shp_gizmo.vertex(0,0,s)
    shp_gizmo.end_shape
  end
  shape(shp_gizmo)
end
