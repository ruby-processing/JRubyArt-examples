#
# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
#
# https://github.com/diwi/PixelFlow.git
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
load_library :PixelFlow

java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'
#
# Shadertoy Demo:   https://www.shadertoy.com/view/Xds3zN
# Shadertoy Author: https://www.shadertoy.com/user/iq
#
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
  @toy = DwShadertoy.new(context, data_path('raymarching_primitives.frag'))
  frame_rate(60)
end

def draw
  toy.set_iMouse(mouse_x, height - 1 - mouse_y, mouse_x, height - 1 - mouse_y)
  toy.apply(g)
  format_string = 'Shadertoy Raytracing Primitives [size %d/%d] [frame %d] [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, frame_count, frame_rate))
end
