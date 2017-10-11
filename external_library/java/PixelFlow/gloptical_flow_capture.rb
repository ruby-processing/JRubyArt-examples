load_library :PixelFlow, :glvideo
java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter'
java_import 'gohai.glvideo.GLCapture'
#
# PixelFlow | Copyright (C) 2016-17 Thomas Diewald - http://thomasdiewald.com
# Translated to JRubyArt by Martin Prout
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
#
# Example, Optical Flow for Webcam capture.

attr_reader :context, :opticalflow, :pg_cam, :pg_oflow, :cam

def settings
  size(1280, 960, P2D)
  smooth(4)
end

def setup
  sketch_title 'Optical Flow Capture'
  # main library context
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  # optical flow
  @opticalflow = DwOpticalFlow.new(context, width, height)
  #    cameras = Capture.list
  #    puts(cameras)
  #    @cam = Capture.new(self, cameras[0])
  # Capture, video library
  @cam = GLCapture.new(self)
  cam.start
  @pg_cam = create_graphics(width, height, P2D)
  pg_cam.no_smooth
  @pg_oflow = create_graphics(width, height, P2D)
  pg_oflow.smooth(4)
  background(0)
  frame_rate(60)
end

def draw
  if cam.available
    cam.read
    # render to offscreenbuffer
    pg_cam.begin_draw
    pg_cam.image(cam, 0, 0, width, height)
    pg_cam.end_draw
    # update Optical Flow
    opticalflow.update(pg_cam)
  end
  # rgba -> luminance (just for display)
  DwFilter::get(context).luminance.apply(pg_cam, pg_cam)
  # render Optical Flow
  pg_oflow.begin_draw
  pg_oflow.clear
  pg_oflow.image(pg_cam, 0, 0, width, height)
  pg_oflow.end_draw
  # flow visualizations
  opticalflow.param.display_mode = 0
  opticalflow.render_velocity_shading(pg_oflow)
  opticalflow.render_velocity_streams(pg_oflow, 10)
  # display result
  background(0)
  image(pg_oflow, 0, 0)
end
