# PixelFlow v1.03
# Shadertoy Demo:   https://www.shadertoy.com/view/ldyGWm
# Shadertoy Author: https://www.shadertoy.com/user/Shane

load_library :PixelFlow

module Shadertoy
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'
  java_import 'com.jogamp.opengl.GL2'
  java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTextureUtils'
end

include Shadertoy

attr_reader :context, :toy

def settings
  size(1280, 720, P2D)
  smooth(0)
end

def setup
  surface.set_resizable(true)

  @context = DwPixelFlow.new(self)
  context.print
  context.printGL

  @toy = DwShadertoy.new(context, data_path('MengerSponge.frag'))
  pg_albedo = create_graphics(512, 512, P2D)
  DwGLTextureUtils::changeTextureWrap pg_albedo, GL2::GL_MIRRORED_REPEAT
  DwGLTextureUtils::changeTextureFilter pg_albedo, GL2::GL_LINEAR, GL2::GL_LINEAR

  pg_albedo.beginDraw
  pg_albedo.background(200,100,5)
  pg_albedo.endDraw

  frameRate(60)
end

def mouse_dragged
  toy.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
end

def draw
  toy.apply(g)
  format_string = 'Shadertoy  [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, frame_count, frame_rate))
end
