load_library :PixelFlow
java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter'
#
# PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
#
# A Processing/Java library for high performance GPU-Computing (GLSL).
# MIT License: https://opensource.org/licenses/MIT
#
#
# Bloom Shader applied as post-processing effect on a simple 2D scene.
#
VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0

attr_reader :context, :filter, :pg_render, :pg_luminance, :pg_bloom, :font12
attr_reader :display_mode

def settings
  size(VIEWPORT_W, VIEWPORT_H, P2D)
  smooth(0)
end

def setup
  surface.setLocation(VIEWPORT_X, VIEWPORT_Y)
  @display_mode = '1'
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  @filter = DwFilter.new(context)
  @pg_render = create_graphics(width, height, P2D)
  pg_render.smooth(8)
  @pg_luminance = create_graphics(width, height, P2D)
  pg_luminance.smooth(8)
  @pg_bloom = create_graphics(width, height, P2D)
  pg_bloom.smooth(8)
  @font12 = create_font("SourceCodePro-Regular", 12)
  background(0)
  #    frame_rate(60)
  frame_rate(1000)
end

def draw
  # just draw something into pg_src_A
  pg_render.begin_draw
  pg_render.blend_mode(BLEND) # default
  pg_render.rect_mode(CENTER)
  pg_render.background(0)
  num_x = 20
  num_y = (num_x / (width /  height)).ceil
  size_x = (width  - 1) / num_x.to_f
  size_y = (height - 1) / num_y.to_f
  scale_xy = 0.4
  grid(num_y, num_x) do |y, x| # using the JRubyArt convenience grid method
    px = x * size_x + size_x * 0.5
    py = y * size_y + size_y * 0.5
    norm_x = x / (num_x - 1).to_f
    norm_y = y / (num_y - 1).to_f
    rgb_r = 255 - 255 * norm_x * norm_y
    rgb_g = norm_x * 255
    rgb_b = norm_y * 255
    col = color(rgb_r, rgb_g, rgb_b)
    pg_render.push_matrix
    pg_render.translate(px, py)
    pg_render.stroke_weight(2)
    pg_render.stroke(col)
    if( ((x^y)&1) == 0)
      pg_render.fill(col)
    else
      pg_render.no_fill
    end
    pg_render.rect(0, 0, size_x * scale_xy, size_y * scale_xy, 0)
    pg_render.pop_matrix
  end
  pg_render.stroke(255)
  pg_render.fill(0, 240)
  pg_render.stroke_weight(2)
  pg_render.ellipse(mouse_x, mouse_y, height / 4, height / 4)
  pg_render.end_draw
  unless display_mode == '0'
    # luminance pass
    filter.luminance_threshold.param.threshold = 0.0 # when 0, all colors are used
    filter.luminance_threshold.param.exponent = 5
    filter.luminance_threshold.apply(pg_render, pg_luminance)

    # bloom pass
    # if the original image is used as source, the previous luminance pass
    # can just be skipped
    filter.bloom.param.mult = map1d(mouse_x, 0..width, 0..10)
    filter.bloom.param.radius = map1d(mouse_y, 0..height, 0..1)
    filter.bloom.apply(pg_luminance, pg_bloom, pg_render)
  end
  case(display_mode)
  when '2'
    filter.copy.apply(pg_bloom, pg_render)
  when '3'
    filter.copy.apply(pg_luminance, pg_render)
  when '4'
    filter.copy.apply(filter.bloom.gaussianpyramid.tex_blur[0], pg_render)
  when '5'
    filter.copy.apply(filter.bloom.gaussianpyramid.tex_blur[1], pg_render)
  when '6'
    filter.copy.apply(filter.bloom.gaussianpyramid.tex_blur[2], pg_render)
  when '7'
    filter.copy.apply(filter.bloom.gaussianpyramid.tex_blur[3], pg_render)
  when '8'
    filter.copy.apply(filter.bloom.gaussianpyramid.tex_blur[4], pg_render)
  end
  # display result
  blend_mode(REPLACE)
  background(0)
  image(pg_render, 0, 0)

  # mouse position hints
  s = 3
  blend_mode(BLEND)
  stroke_cap(SQUARE)
  stroke_weight(s * 2)
  stroke(0, 50)
  line(0, s, width, s)
  line(s, 0, s, height)
  stroke(0, 160)
  line(0, s, mouse_x, s)
  line(s, 0, s, mouse_y)
  # info
  format_string = 'Bloom Demo [size %d/%d] [mode %d] [frame %d] [fps: (%6.2f)]'
  fps = format(format_string, pg_render.width, pg_render.height, display_mode, frame_count, frame_rate)
  surface.set_title(fps)
  # ke_y hints
  text_font(font12)
  tx = 15
  ty = 15
  gap = 15
  stroke(255)
  text(fps, tx, ty += gap)
  text("'0' bloom OFF" , tx, ty += gap)
  text("'1' Bloom ON"  , tx, ty += gap)
  text("'2' bloom only", tx, ty += gap)
  text("'3' Luminance" , tx, ty += gap)
  text("'4' Blur[0]"   , tx, ty += gap)
  text("'5' Blur[1]"   , tx, ty += gap)
  text("'6' Blur[2]"   , tx, ty += gap)
  text("'7' Blur[3]"   , tx, ty += gap)
  text("'8' Blur[4]"   , tx, ty += gap)
  text("mouseX: bloom multiplier"   , tx, ty += gap)
  text("mouseY: bloom radius"       , tx, ty += gap)
end

def key_released
  case key
  when '0'..'8'
    @display_mode = key
  end
end
