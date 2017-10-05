load_library :PixelFlow

java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'

#
# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
#
# https://github.com/diwi/PixelFlow.git
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
# Shadertoy Demo:   https://www.shadertoy.com/view/ldSSzV
# Shadertoy Author: https://www.shadertoy.com/user/TDM
#
attr_reader :context, :toy

def settings
  size(1280, 720, P2D)
  smooth(0)
end

def setup
  surface.setResizable(true)
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  @toy = DwShadertoy.new(context, data_path('wet_stone.frag'))
  frame_rate(60)
end

def draw
  toy.set_iMouse(mouse_x, height - 1 - mouse_y, mouse_x, height - 1 - mouse_y) if mouse_pressed?
  toy.apply(g)
  title_format = 'Shadertoy Wet Stone | size: [%d, %d] frame_count: %d fps: %6.2f'
  surface.set_title(format(title_format, width, height, frame_count, frame_rate))
end
