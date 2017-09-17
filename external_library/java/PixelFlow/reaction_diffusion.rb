load_library :PixelFlow

# PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
# translated to JRubyArt by MArtihn Prout
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
module Reaction
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram'
  java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture'
  java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter'
  java_import 'com.jogamp.opengl.GL2'
end

include Reaction
# reaction-diffusion, grayscott
#
# using custom shaders/textures for fast multipass rendering.
attr_reader :context, :tex_grayscott, :shader_grayscott, :shader_render
attr_reader :pass, :tex_render

def settings
  size(800, 800, P2D)
  smooth(0)
end

def setup
  # multipass rendering texture
  @tex_grayscott = DwGLTexture::TexturePingPong.new
  # pixelflow context
  @context = DwPixelFlow.new(self)
  @pass = 0
  # 1) 32 bit per channel
  tex_grayscott.resize(
    context,
    GL2::GL_RG32F, # NB we need :: not . here to access constant
    width,
    height,
    GL2::GL_RG,
    GL2::GL_FLOAT,
    GL2::GL_NEAREST,
    2,
    4
  )

  # 2) 16 bit per channel, lack of precision is obvious in the result, its fast though
  # tex_grayscott.resize(context, GL2::GL_RG16F, width, height, GL2::GL_RG, GL2::GL_FLOAT, GL2::GL_NEAREST, 2, 2)

  # 3) 16 bit per channel, better than 2)
  # tex_grayscott.resize(context, GL2::GL_RG16_SNORM, width, height, GL2::GL_RG, GL2::GL_FLOAT, GL2::GL_NEAREST, 2, 2)

  # glsl shader
  @shader_grayscott = context.createShader(data_path('grayscott.frag'))
  @shader_render = context.createShader(data_path('render.frag'))
  # init
  @tex_render = create_graphics(width, height, P2D)
  tex_render.smooth(0)
  tex_render.beginDraw
  tex_render.textureSampling(2)
  tex_render.blendMode(REPLACE)
  tex_render.clear
  tex_render.noStroke
  tex_render.background(0x00FF0000) # NB: we can use hexadecimal in ruby
  tex_render.fill(0x0000FF00)
  tex_render.noStroke
  tex_render.rectMode(CENTER)
  tex_render.rect(width / 2, height / 2, 20, 20)
  tex_render.endDraw
  # copy initial data to source texture
  DwFilter.get(context).copy.apply(tex_render, tex_grayscott.src)
  frame_rate(1_000)
end

def reaction_diffusion_pass
  context.beginDraw(tex_grayscott.dst)
  shader_grayscott.begin
  shader_grayscott.uniform1f('dA', 1.0)
  shader_grayscott.uniform1f('dB', 0.5)
  shader_grayscott.uniform1f('feed', 0.055)
  shader_grayscott.uniform1f('kill', 0.062)
  shader_grayscott.uniform1f('dt', 1)
  shader_grayscott.uniform2f('wh_rcp', 1.0 / width, 1.0 / height)
  shader_grayscott.uniformTexture('tex', tex_grayscott.src)
  shader_grayscott.drawFullScreenQuad
  shader_grayscott.end
  context.endDraw('reaction_diffusion_pass')
  tex_grayscott.swap
  @pass += 1
end

def draw
  # multipass rendering, ping-pong
  context.begin
  100.times { reaction_diffusion_pass }
  # create display texture
  context.beginDraw(tex_render)
  shader_render.begin
  shader_render.uniform2f('wh_rcp', 1.0 / width, 1.0 / height)
  shader_render.uniformTexture('tex', tex_grayscott.src)
  shader_render.drawFullScreenQuad
  shader_render.end
  context.endDraw('render')
  context.end
  # put it on the screen
  blendMode(REPLACE)
  image(tex_render, 0, 0)
  save_frame(data_path('grayscott1.jpg')) if frame_count == 1_000
  format_string = 'Reaction Diffusion  [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, pass, frame_rate))
end
