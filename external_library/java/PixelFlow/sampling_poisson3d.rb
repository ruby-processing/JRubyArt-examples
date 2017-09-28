#
# PixelFlow | Copyright (C) 2016 Thomas Diewald - http:#thomasdiewald.com
#
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https:#opensource.org/licenses/MIT
#
load_library :PixelFlow, :peasycam

module Poisson
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwCube'
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwIcosahedron'
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwIndexedFaceSetAble'
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwMeshUtils'
  java_import 'com.thomasdiewald.pixelflow.java.sampling.PoissonDiscSamping3D'
  java_import 'com.thomasdiewald.pixelflow.java.sampling.PoissonSample'
  java_import 'peasy.PeasyCam'
  java_import 'processing.core.PShape'
end

include Poisson

attr_reader :cam, :shp_samples_spheres, :shp_samples_points, :shp_gizmo
attr_reader :display_radius, :generate_spheres, :ifs, :verts_per_face, :samples

def settings
  size(1280, 720, P3D)
  smooth(8)
end

def setup
  sketch_title 'Sampling Poisson 3D'
  @cam = PeasyCam.new(self, 0, 0, 0, 1000)
  @display_radius = true
  @generate_spheres = true
  @ifs = nil
  @shp_gizmo = nil
  @verts_per_face = 0
  generate_poisson_sampling
  frame_rate(1_000)
end

def generate_poisson_sampling
  # create an anonymous class instance in JRuby that implements the java
  # abstract class PoissonDiscSamping3D
  pds = Class.new(PoissonDiscSamping3D) do
    # java_signature 'PoissonSample newInstance(float, float, float, float, float)'
    def newInstance(x, y, z, r, rcollision)
      PoissonSample.new(x, y, z, r, rcollision)
    end
  end.new
  bounds = [-200, -200, 0, 200, 200, 400]
  rmin = 10
  rmax = 50
  roff = 1
  new_points = 50
  start = Time.now
  pds.generatePoissonSampling(bounds, rmin, rmax, roff, new_points)
  @shp_samples_spheres = create_shape(GROUP)
  @shp_samples_points  = create_shape(GROUP)
  @samples = pds.samples
  samples.each do |sample|
    add_shape(sample)
  end
  time = Time.now - start
  start = Time.now
  puts("poisson samples 3D generated")
  puts("    time: #{(time * 1_000).floor}ms")
  puts("    count: #{pds.samples.size}")

  time = Time.now - start
  puts("PShapes created")
  puts("    time: #{(time * 1_000).floor}ms")
  puts("    count: #{samples.size}")
end

def draw
  lights
  point_light(128, 96, 64, -500, -500, -1_000)
  # directionalLight(128, 96, 64, -500, -500, +1_000)
  background(64)
  display_gizmo(500)
  if display_radius
    shape(shp_samples_spheres)
  else
    shape(shp_samples_points)
  end
end

def add_shape(sample)
  shp_point = create_shape(POINT, sample.x, sample.y, sample.z)
  shp_point.set_stroke(color(255))
  shp_point.set_stroke_weight(3)
  shp_samples_points.add_child(shp_point)
  if ifs.nil?
    @ifs = DwIcosahedron.new(2)
    @verts_per_face = 3
    # @ifs = DwCube.new(2)
    # @verts_per_face = 4
  end
  shp_sphere = create_shape(PShape::GEOMETRY)
  shp_sphere.set_stroke(false)
  shp_sphere.set_fill(color(255))
  shp_sphere.reset_matrix
  shp_sphere.translate(sample.x, sample.y, sample.z)
  DwMeshUtils::createPolyhedronShape(shp_sphere, ifs, sample.rad, verts_per_face, true)
  shp_samples_spheres.add_child(shp_sphere)
  # @shp_sphere_normals = createShape(PShape::GEOMETRY)
  # shp_sphere_normals.setStroke(false)
  # shp_sphere_normals.setFill(color(255))
  # shp_sphere_normals.resetMatrix
  # shp_sphere_normals.translate(sample.x, sample.y, sample.z)
  # DwMeshUtils::createPolyhedronShapeNormals(shp_sphere_normals, ifs, sample.rad, 10)
  # shp_samples_spheres.addChild(shp_sphere_normals)
end

def display_gizmo(s)
  if shp_gizmo.nil?
    stroke_weight(1)
    @shp_gizmo = create_shape
    shp_gizmo.begin_shape(LINES)
    shp_gizmo.stroke(255, 0, 0)
    shp_gizmo.vertex(0, 0, 0)
    shp_gizmo.vertex(s, 0, 0)
    shp_gizmo.stroke(0, 255, 0)
    shp_gizmo.vertex(0, 0, 0)
    shp_gizmo.vertex(0, s, 0)
    shp_gizmo.stroke(0, 0, 255)
    shp_gizmo.vertex(0, 0, 0)
    shp_gizmo.vertex(0, 0, s)
    shp_gizmo.end_shape
  end
  shape shp_gizmo
end

def key_released
  case key
  when ' '
    @display_radius = !display_radius
  when 'r'
    generate_poisson_sampling
  end
end
