#
#
# PixelFlow | Copyright (C) 2017 Thomas Diewald (www.thomasdiewald.com)
# Translated to JRubyArt by Martin Prout
#
# src  - www.github.com/diwi/PixelFlow
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
load_libraries :peasycam, :PixelFlow

module Skylight # Namespace for java classes
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.render.skylight.DwSkyLight'
  java_import 'com.thomasdiewald.pixelflow.java.utils.DwBoundingSphere'
  java_import 'com.thomasdiewald.pixelflow.java.utils.DwVertexRecorder'
  java_import 'peasy.PeasyCam'
end

include Skylight
# Basic setup for the Skylight renderer.
#
# Its important to compute or define a most optimal bounding-sphere for the
# scene. self can be done manually or automatically, as shown in self example.
#
# Any existing sketch utilizing the P3D renderer can be extended to use the
# Skylight renderer.
#
VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0
attr_reader :peasycam, :shape, :skylight, :cam_active, :cam_pos

def settings
  size(VIEWPORT_W, VIEWPORT_H, P3D)
  smooth(0)
end

def setup
  surface.setLocation(VIEWPORT_X, VIEWPORT_Y)
  # camera
  @peasycam = PeasyCam.new(self, -4.083, -6.096, 7.000, 1500)
  peasycam.set_rotations(1.085, -0.477, 2.910)
  peasycam.set_distance(100)
  @cam_pos = [0, 0, 0]
  @cam_active = false
  # projection
  perspective(60 * DEG_TO_RAD, width / height.to_f, 2, 5000)
  # load obj file into shape-object
  @shape = load_shape(data_path('skylight_demo_scene.obj'))
  # record list of vertices of the given shape
  vertex_recorder = DwVertexRecorder.new(self, shape)
  # compute scene bounding-sphere
  scene_bs = DwBoundingSphere.new
  scene_bs.compute(vertex_recorder.verts, vertex_recorder.verts_count)
  # used for centering and re-scaling the scene
  mat_scene_bounds = scene_bs.getUnitSphereMatrix
  # library context
  context = DwPixelFlow.new(self)
  context.print
  context.printGL
  # callback for rendering scene, implements DwSceneDisplay interface
  display = lambda do |canvas|
    canvas.background(32) if canvas == skylight.renderer.pg_render
    canvas.shape(shape)
  end
  # init skylight renderer
  @skylight = DwSkyLight.new(context, display, mat_scene_bounds)
  # parameters for sky-light
  param = skylight.sky.param
  param.iterations = 50
  param.solar_azimuth = 0
  param.solar_zenith = 0
  param.sample_focus = 1 # full sphere sampling
  param.intensity = 1.0
  param.rgb = [1.0, 1.0, 1.0]
  param.shadowmap_size = 256 # quality vs. performance
  # parameters for sun-light
  param = skylight.sun.param
  param.iterations = 50
  param.solar_azimuth = 45
  param.solar_zenith = 55
  param.sample_focus = 0.05
  param.intensity = 1.0
  param.rgb = [1.0, 1.0, 1.0]
  param.shadowmap_size = 512
  frame_rate(1000)
end

def draw
  # when the camera moves, the renderer restarts
  update_cam_active
  skylight.reset if cam_active
  # update renderer
  skylight.update
  peasycam.beginHUD
  # display result
  image(skylight.renderer.pg_render, 0, 0)
  # image(skylight.sky.getSrc, 0, 0)
  peasycam.endHUD
  # some info, window title
  sun_pass = skylight.sun.RENDER_PASS
  sky_pass = skylight.sky.RENDER_PASS
  title_format = 'Basic Skylight | sun: %d sky: %d fps: %6.2f'
  surface.set_title(format(title_format, sun_pass, sky_pass, frame_rate))
end

def update_cam_active
  cam_pos_curr = peasycam.getPosition
  @cam_active = false
  @cam_active |= cam_pos_curr[0] != cam_pos[0]
  @cam_active |= cam_pos_curr[1] != cam_pos[1]
  @cam_active |= cam_pos_curr[2] != cam_pos[2]
  @cam_pos = cam_pos_curr
end

def print_camera
  pos = peasycam.get_position
  rot = peasycam.get_rotations
  lat = peasycam.get_look_at
  dis = peasycam.get_distance
  cam_format = '%s: (%7.3f, %7.3f, %7.3f)'
  dist_format = 'distance: (%7.3f)'
  puts format(cam_format, 'position', pos[0], pos[1], pos[2])
  puts format(cam_format, 'rotation', rot[0], rot[1], rot[2])
  puts format(cam_format, 'look_at', lat[0], lat[1], lat[2])
  puts format(dist_format, dis)
end

def key_released
  print_camera
end
