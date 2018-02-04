# PixelFlow | Copyright (C) 2017 Thomas Diewald - www.thomasdiewald.com
# Translate to JRubyArt by Martin Prout
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

WH = 256
TITLE = 'Shadertoy Expansive Reaction Diffusion'.freeze
attr_reader :context, :toys

def settings
  size(1280, 720, P2D)
  smooth(0)
end

def create_shadertoys
  buffers = %w[_BufA _BufB _BufC _BufD]
  buffers << ''
  @toys = buffers.map do |frag|
    DwShadertoy.new(context, data_path("ExpansiveReactionDiffusion#{frag}.frag"))
  end
end

def set_channels
  toys[0].set_iChannel(0, toys[0])
  toys[0].set_iChannel(1, toys[2])
  toys[0].set_iChannel(2, toys[3])
  toys[0].set_iChannel(3, tex_noise)
  toys[0].apply(width, height)
  toys[1].set_iChannel(0, toys[0])
  toys[1].apply(width, height)
  toys[2].set_iChannel(0, toys[1])
  toys[2].apply(width, height)
  toys[3].set_iChannel(0, toys[0])
  toys[3].apply(width, height)
  toys[4].set_iChannel(0, toys[0])
  toys[4].set_iChannel(2, toys[2])
  toys[4].set_iChannel(3, tex_noise)
  toys[4].apply(g)
end

def setup
  surface.set_resizable(true)
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  create_shadertoys
  frame_rate(60)
end

def tex_noise
  texture = DwGLTexture.new
  bdata = []
  (0...WH * WH * 4).step(4) do
    bdata << rand(0..125) # NB: java bytes are signed
    bdata << rand(0..125)
    bdata << rand(0..125)
    bdata << -125
  end
  texture.resize(
    context,
    GL2::GL_RGBA8,
    WH,
    WH,
    GL2::GL_RGBA,
    GL2::GL_BYTE,
    GL2::GL_LINEAR,
    GL2::GL_MIRRORED_REPEAT,
    4,
    1,
    Java::JavaNio::ByteBuffer.wrap(bdata.to_java(Java::byte))
  )
  texture
end

def draw
  blend_mode(REPLACE)
  if mouse_pressed?
    toys.each do |toy|
      toy.set_iMouse(mouse_x, height-1-mouse_y, mouse_x, height-1-mouse_y)
    end
  end
  set_channels
  title_format = '%s | size: [%d, %d] frame_count: %d fps: %6.2f'
  surface.set_title(
    format(title_format, TITLE, width, height, frame_count, frame_rate)
  )
end
