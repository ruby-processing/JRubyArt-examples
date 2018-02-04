#
#
# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
#
# https://github.com/diwi/PixelFlow.git
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
# Shadertoy Demo:   https://www.shadertoy.com/view/4dcGW2
# Shadertoy Author: https://www.shadertoy.com/user/Flexi
#
load_library :PixelFlow
java_import 'java.nio.ByteBuffer'
java_import 'com.jogamp.opengl.GL2'
java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.DwShadertoy'

  attr_reader :context, :toy, :toyA, :toyB, :toyC, :toyD, :tex_noise

  def settings
    size(1280, 720, P2D)
    smooth(0)
  end

  def setup
    surface.set_resizable(true)
    context = DwPixelFlow.new(self)
    context.print
    context.printGL
    @tex_noise = DwGLTexture.new
    @toyA = DwShadertoy.new(context, data_path('ExpansiveReactionDiffusion_BufA.frag'))
    @toyB = DwShadertoy.new(context, data_path('ExpansiveReactionDiffusion_BufB.frag'))
    @toyC = DwShadertoy.new(context, data_path('ExpansiveReactionDiffusion_BufC.frag'))
    @toyD = DwShadertoy.new(context, data_path('ExpansiveReactionDiffusion_BufD.frag'))
    @toy  = DwShadertoy.new(context, data_path('ExpansiveReactionDiffusion.frag'))
    # create noise texture
    wh = 256
    bdata = []
    (0...wh * wh * 4).step(4) do
      bdata << rand(-125..125) # NB: java bytes are signed
      bdata << rand(-125..125)
      bdata << rand(-125..125)
      bdata << 125
    end
    bbuffer = Java::JavaNio::ByteBuffer.wrap(bdata.to_java(Java::byte))
    tex_noise.resize(context, GL2::GL_RGBA8, wh, wh, GL2::GL_RGBA, GL2::GL_BYTE, GL2::GL_LINEAR, GL2::GL_MIRRORED_REPEAT, 4, 1, bbuffer)
    frame_rate(60)
  end

  def draw
    blend_mode(REPLACE)
    if mouse_pressed?
      toyA.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
      toyB.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
      toyC.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
      toyD.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
      toy.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
    end
    toyA.set_iChannel(0, toyA)
    toyA.set_iChannel(1, toyC)
    toyA.set_iChannel(2, toyD)
    toyA.set_iChannel(3, tex_noise)
    toyA.apply(width, height)
    toyB.set_iChannel(0, toyA)
    toyB.apply(width, height)
    toyC.set_iChannel(0, toyB)
    toyC.apply(width, height)
    toyD.set_iChannel(0, toyA)
    toyD.apply(width, height)
    toy.set_iChannel(0, toyA)
    toy.set_iChannel(2, toyC)
    toy.set_iChannel(3, tex_noise)
    toy.apply(g)
    title_format = 'Shadertoy Expansive Reaction Diffusion | size: [%d, %d] frame_count: %d fps: %6.2f'
    surface.set_title(format(title_format, width, height, frame_count, frame_rate))
  end
