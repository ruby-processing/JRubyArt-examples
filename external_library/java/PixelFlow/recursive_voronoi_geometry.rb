# PixelFlow v1.03
# Shadertoy Demo:   https://www.shadertoy.com/view/ldyGWm
# Shadertoy Author: https://www.shadertoy.com/user/Shane

load_library :PixelFlow

module Shadertoy
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'
  java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture'
  java_import 'com.jogamp.opengl.GL2'
  java_import 'com.thomasdiewald.pixelflow.java.utils.DwUtils'
end

include Shadertoy

attr_reader :toy, :tex0

def settings
  size(1280, 720, P2D)
  smooth(0)
end

def setup
  surface.set_resizable(true)
  context = DwPixelFlow.new(self)
  context.print
  context.printGL
  @tex0 = DwGLTexture.new
  @toy = DwShadertoy.new(context, data_path('recursive_voronoi.frag'))
  tex0.resize(context, width, height)
  frame_rate(60)
end

def draw
  toy.set_iChannel(0, tex0)
  toy.apply(g)
  format_string = 'Shadertoy  [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, frame_count, frame_rate))
  rect(0, 0, width, height)
end
