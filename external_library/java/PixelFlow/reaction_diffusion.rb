load_library :PixelFlow

# PixelFlow | Copyright (C) 2016-17 Thomas Diewald - http://thomasdiewald.com
# translated to JRubyArt by Martin Prout
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
    GL2::GL_RG32F, # NB use :: not . here to access GL2 constants
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
  @shader_grayscott = context.create_shader(data_path('grayscott.frag'))
  @shader_render = context.create_shader(data_path('render.frag'))
  # init
  @tex_render = create_graphics(width, height, P2D)
  tex_render.smooth(0)
  tex_render.begin_draw
  tex_render.texture_sampling(2)
  tex_render.blend_mode(REPLACE)
  tex_render.clear
  tex_render.no_stroke
  tex_render.background(0x00FF0000) # NB: we can use hexadecimal in ruby
  tex_render.fill(0x0000FF00)
  tex_render.rect_mode(CENTER)
  tex_render.rect(width / 2, height / 2, 20, 20)
  tex_render.end_draw
  # copy initial data to source texture
  DwFilter.get(context).copy.apply(tex_render, tex_grayscott.src)
  frame_rate(1_000)
end

def reaction_diffusion_pass
  context.begin_draw(tex_grayscott.dst)
  shader_grayscott.begin
  shader_grayscott.uniform1f('dA', 1.0)
  shader_grayscott.uniform1f('dB', 0.5)
  shader_grayscott.uniform1f('feed', 0.055)
  shader_grayscott.uniform1f('kill', 0.062)
  shader_grayscott.uniform1f('dt', 1)
  shader_grayscott.uniform2f('wh_rcp', 1.0 / width, 1.0 / height)
  shader_grayscott.uniformTexture('tex', tex_grayscott.src)
  shader_grayscott.draw_full_screen_quad
  shader_grayscott.end
  context.end_draw('reaction_diffusion_pass')
  tex_grayscott.swap
  @pass += 1
end

def draw
  # multipass rendering, ping-pong
  context.begin
  100.times { reaction_diffusion_pass }
  # create display texture
  context.begin_draw(tex_render)
  shader_render.begin
  shader_render.uniform2f('wh_rcp', 1.0 / width, 1.0 / height)
  shader_render.uniform_texture('tex', tex_grayscott.src)
  shader_render.draw_full_screen_quad
  shader_render.end
  context.end_draw('render')
  context.end
  # put it on the screen
  blend_mode(REPLACE)
  image(tex_render, 0, 0)
  save_frame(data_path('grayscott1.jpg')) if frame_count == 1_000
  format_string = 'Reaction Diffusion  [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, width, height, pass, frame_rate))
end
