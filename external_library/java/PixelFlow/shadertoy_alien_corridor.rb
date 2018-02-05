load_library :PixelFlow

java_import 'com.jogamp.opengl.GL2'
java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'
java_import 'com.thomasdiewald.pixelflow.java.utils.DwUtils'
# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
#
# https://github.com/diwi/PixelFlow.git
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
# Shadertoy Demo:   https://www.shadertoy.com/view/4slyRs
# Shadertoy Author: https://www.shadertoy.com/user/zguerrero
attr_reader :context, :toy, :toyA, :toyB, :toyC, :toyD, :pg_noise
TITLE = 'Shadertoy Alien Corridor'.freeze

def settings
  size(1280, 720, P2D)
  smooth(0)
end

def setup
  surface.set_resizable(true)
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  create_toys
  pg_noise.begin_draw
  pg_noise.no_stroke
  grid(pg_noise.width, pg_noise.height) do |x, y|
    scale = 0.02
    gray = (noise(x * scale, y * scale) * 255).to_i
    argb = 255<<24 | gray<<16 | gray<<8 | gray
    pg_noise.fill(color(argb)) # Using color for hexadecimal values in JRubyArt
    pg_noise.rect(x, y, 1, 1)
  end
  pg_noise.end_draw
  frame_rate(600)
end

def create_toys
  @toyA  = DwShadertoy.new(context, data_path('AlienCorridor_BufA.frag'))
  @toyB  = DwShadertoy.new(context, data_path('AlienCorridor_BufB.frag'))
  @toyC  = DwShadertoy.new(context, data_path('AlienCorridor_BufC.frag'))
  @toyD  = DwShadertoy.new(context, data_path('AlienCorridor_BufD.frag'))
  @toy   = DwShadertoy.new(context, data_path('AlienCorridor.frag'))
  @pg_noise = create_graphics(512, 512, P2D)
  pg_noise.smooth(0)
  DwUtils.change_texture_wrap(pg_noise, GL2::GL_MIRRORED_REPEAT)
  DwUtils.change_texture_filter(pg_noise, GL2::GL_LINEAR, GL2::GL_LINEAR)
end

def draw
  toyA.set_iChannel(0, pg_noise)
  toyA.apply(width, height)
  toyB.set_iChannel(0, toyA)
  toyB.apply(width, height)
  toyC.set_iChannel(0, toyB)
  toyC.apply(width, height)
  toyD.set_iChannel(0, toyC)
  toyD.apply(width, height)
  toy.set_iChannel(0, toyD)
  toy.set_iChannel(1, toyA)
  toy.apply(g)
  title_format = '%s | size: [%d, %d] frame_count: %d fps: %6.2f'
  surface.set_title(
    format(title_format, TITLE, width, height, frame_count, frame_rate)
  )
end
