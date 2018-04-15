load_libraries :PixelFlow, :control_panel

image_proc = %w[DwFlowField DwHarrisCorner]
filters = %w[
  BinomialBlur DwFilter Laplace Median Merge MinMaxGlobal Sobel SummedAreaTable
]
filter_format = 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.%s'
img_proc_format = 'com.thomasdiewald.pixelflow.java.imageprocessing.%s'
java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture'
image_proc.each do |ip|
  java_import format(img_proc_format, ip)
end
filters.each do |filter|
  java_import format(filter_format, filter)
end
java_import 'com.jogamp.opengl.GL'

GUI_WIDTH = 200
VIEW_WIDTH = 927
VIEW_HEIGHT = 1000
KERNEL =
  [
    [ # lowpass: box-blur
      1 / 9.0, 1 / 9.0, 1 / 9.0,
      1 / 9.0, 1 / 9.0, 1 / 9.0,
      1 / 9.0, 1 / 9.0, 1 / 9.0
    ],
    [ # lowpass: gauss-blur
      1 / 16.0, 2 / 16.0, 1 / 16.0,
      2 / 16.0, 4 / 16.0, 2 / 16.0,
      1 / 16.0, 2 / 16.0, 1 / 16.0
    ],
    [ # sharpen highpass: laplace
      0, -1, 0,
      -1, 5,-1,
      0, -1, 0
    ],
    [ # sharpen highpass: laplace
      -1, -1, -1,
      -1, 9, -1,
      -1, -1, -1
    ],
    [ # sharpen highpass: laplace
      -1, -2, -1,
      -2, 13, -2,
      -1, -2, -1
    ],
    [ # edges 1
      +0, +1, +0,
      +1, -4, +1,
      +0, +1, +0
    ],
    [ # edges 2
      +1, +1, +1,
      +1, -8, +1,
      +1, +1, +1
    ],
    [ # gradient: sobel horizontal
      +1, 0, -1,
      +2, 0, -2,
      +1, 0, -1
    ],
    [ # gradient: sobel vertical
      +1, +2, +1,
      0, 0, 0,
      -1, -2, -1
    ],
    [ # gradient: sobel diagonal TL-BR
      +2, 1 ,0,
      +1, 0, -1,
      +0, -1, -2
    ],
    [  # gradient: sobel diagonal TR-BL
      0, -1, -2,
      +1, 0, -1,
      +2, +1, 0
    ],
    [  # emboss / structure / relief
      0, -1, -2,
      +1, 1, -1,
      +2, +1, 0
    ]
  ].freeze

FILTERS = %w[
  luminance box\ blur Summed\ Area\ Table\ blur gauss\ blur binomial\ blur
  bilateral convolution median\ 3x3  median\ 5x5 sobel\ 3x3\ vert
  sobel\ 3x3\ horz sobel\ 3x3\ horz/vert laplace Dog median\ +\ gauss\ +\ laplace
  median\ +\ gauss\ +\ sobel(H) Harris\ Corner\ Detection Bloom
  Luminance\ Threshold Luminance\ Threshold\ +\ Bloom
  Distance\ Transform\ /\ Voronoi Flow Min\ Max\ Mapping None
]

GAUSSBLUR_AUTO_SIGMA = true
# bilateral filter
BILATERAL_RADIUS = 5
BILATERAL_SIGMA_COLOR = 0.3
BILATERAL_SIGMA_SPACE = 5
PEPPER = 1000

attr_reader :context, :flowfield, :minmax_global, :harris, :filter
attr_reader :tex_a, :pg_src_a, :pg_src_b, :pg_src_c, :cp5, :img, :laplace_weight
attr_reader :pg_voronoi_centers, :show_geom, :show_image, :animations, :passes
attr_reader :rs, :vel, :pos, :filters, :blur_radius, :conv_kernel_idx

def settings
  size VIEW_WIDTH, VIEW_HEIGHT, P2D
  smooth 8
end

def setup
  @img = load_image(data_path('mc_escher.jpg'))
  @context = DwPixelFlow.new(self)
  @rs = 80
  @pos = Vec2D.new(600, 600)
  @vel = Vec2D.new(0.6, 0.25)
  context.print
  context.printGL
  @flowfield = DwFlowField.new(context)
  @minmax_global = MinMaxGlobal.new(context)
  @harris = DwHarrisCorner.new(context)
  @filter = DwFilter.new(context)
  @pg_src_a = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_a.smooth(8)
  @pg_src_b = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_b.smooth(8)
  pg_src_b.begin_draw
  pg_src_b.clear
  pg_src_b.end_draw
  @pg_src_c = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_c.smooth(8)
  @tex_a = DwGLTexture.new
  tex_a.resize(context, GL::GL_RGBA8, VIEW_WIDTH, VIEW_HEIGHT, GL::GL_RGBA, GL::GL_UNSIGNED_BYTE, GL::GL_NEAREST, 4, 1)
  # random distribution of white pixels, that are used as voronoi centers
  # and serve as a mask for the distance transform.
  gap = 8
  srand(0)
  @pg_voronoi_centers = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_voronoi_centers.smooth(0)
  pg_voronoi_centers.begin_draw
  pg_voronoi_centers.background(0)
  pg_voronoi_centers.stroke(255)
  grid(width, height, gap, gap) do |x, y|
    px = x + rand(gap)
    py = y + rand(gap)
    pg_voronoi_centers.point(px + 0.5, py + 0.5)
  end
  pg_voronoi_centers.end_draw
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title 'Filter Chooser and Settings'
    c.menu :filters, FILTERS, 'Bloom'
    c.menu :conv_kernel_idx, %w[1 2 3 4 5 6 7 8 9 10], '1'
    c.menu :passes, %w[1 2 3 4 5 6 7 8 9], '1'
    c.menu :laplace_weight, %w[0 1 2], '1'
    c.slider :blur_radius, 1..120, 20
    c.checkbox :show_image, true
    c.checkbox :show_geom, true
    c.checkbox :animations, true
  end
  # frame_rate(60)
  frame_rate(1000)
end

def draw
  current = FILTERS.index(filters)
  convolution_kernel_index = conv_kernel_idx.to_i
  gaussblur_sigma = blur_radius / 2.0
  w = VIEW_WIDTH
  h = VIEW_HEIGHT
  # update rectangle position
  @pos += vel
  # keep inside viewport
  if pos.x < rs / 2
    pos.x = rs / 2
    vel.x *= -1
  elsif pos.x > w - rs / 2
    pos.x = w - rs / 2
    vel.x *= -1
  elsif pos.y < rs / 2
    pos.y = rs / 2
    vel.y *= -1
  elsif pos.y > h - rs / 2
    pos.y = h - rs / 2
    vel.y *= -1
  end
  pg_src_c.begin_draw
  pg_src_c.rect_mode(CENTER)
  pg_src_c.background(0)
  if show_geom
    pg_src_c.stroke_weight(1)
    pg_src_c.stroke(0, 255, 0)
    pg_src_c.line(w / 2, 0, w / 2, h)
    pg_src_c.line(0, h / 2, w, h / 2)
    pg_src_c.line(0, 0, w, h)
    pg_src_c.line(w, 0, 0, h)
    pg_src_c.stroke_weight(1)
    pg_src_c.stroke(0, 255, 0)
    pg_src_c.no_fill
    pg_src_c.ellipse(w / 2, h / 2, 150, 150)
    pg_src_c.stroke_weight(1)
    pg_src_c.stroke(0, 255, 0)
    pg_src_c.no_fill
    pg_src_c.rect(w / 2, h / 2, 300, 300)
    srand(1)
    PEPPER.times do
      px = rand(20..w - 20)
      py = rand(20..h - 20)
      pg_src_c.no_stroke
      pg_src_c.fill(0, 255, 0)
      pg_src_c.rect(px, py, 2, 2)
    end
  end
  pg_src_c.end_draw
  # update input image
  pg_src_a.begin_draw
  pg_src_a.rect_mode(CENTER)
  pg_src_a.clear
  pg_src_a.background(255)
  pg_src_a.image(img, 0, 0) if show_image
  if show_geom
    pg_src_a.stroke_weight(1)
    pg_src_a.stroke(0)
    pg_src_a.line(w / 2, 0, w / 2, h)
    pg_src_a.line(0, h / 2, w, h / 2)
    pg_src_a.line(0, 0, w, h)
    pg_src_a.line(w, 0, 0, h)
    pg_src_a.stroke_weight(1)
    pg_src_a.stroke(0)
    pg_src_a.no_fill
    pg_src_a.ellipse(w / 2, h / 2, 150, 150)
    pg_src_a.stroke_weight(1)
    pg_src_a.stroke(0)
    pg_src_a.no_fill
    pg_src_a.rect(w / 2, h / 2, 300, 300)
    srand(1)
    PEPPER.times do
      px = rand(20..w - 20)
      py = rand(20..h - 20)
      pg_src_a.no_stroke
      pg_src_a.fill(0)
      pg_src_a.rect(px, py, 1, 1)
    end
  end
  if animations
    # moving rectangle
    pg_src_a.fill(100, 175, 255)
    pg_src_a.rect(pos.x, pos.y, rs, rs)
    # mouse-driven ellipse
    pg_src_a.fill(255, 150, 0)
    pg_src_a.no_stroke
    pg_src_a.ellipse(mouse_x, mouse_y, 100, 100)
  end
  pg_src_a.end_draw
  # apply filters
  case current
  when 0
    filter.luminance.apply(pg_src_a, pg_src_b)
    swapAB
  when 1
    passes.to_i.times do
      filter.boxblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius)
    end
  when 2
    passes.to_i.times do
      filter.summedareatable.setFormat(SummedAreaTable::InternalFormat::RGBA32F)
      filter.summedareatable.create(pg_src_a)
      filter.summedareatable.apply(pg_src_a, blur_radius)
    end
  when 3
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius, gaussblur_sigma)
    end
  when 4
    filter.binomial.apply(pg_src_a, pg_src_a, pg_src_b, BinomialBlur::TYPE::_15x15)
  when 5
    passes.to_i.times do
      filter.bilateral.apply(pg_src_a, pg_src_b, BILATERAL_RADIUS, BILATERAL_SIGMA_COLOR, BILATERAL_SIGMA_SPACE)
      swapAB
    end
  when 6
    passes.to_i.times do
      filter.convolution.apply(pg_src_a, pg_src_b, KERNEL[convolution_kernel_index].to_java(:float))
      swapAB
    end
  when 7
    filter.median.apply(pg_src_a, pg_src_b, Median::TYPE::_3x3_)
    swapAB
  when 8
    passes.to_i.times do
      filter.median.apply(pg_src_a, pg_src_b, Median::TYPE::_5x5_)
      swapAB
    end
  when 9
    filter.sobel.apply(pg_src_a, pg_src_b, Sobel::TYPE::_3x3_HORZ)
    swapAB
  when 10
    filter.sobel.apply(pg_src_a, pg_src_b, Sobel::TYPE::_3x3_VERT)
    swapAB
  when 11
    filter.sobel.apply(pg_src_a, pg_src_b, Sobel::TYPE::_3x3_HORZ)
    filter.sobel.apply(pg_src_a, pg_src_b, Sobel::TYPE::_3x3_VERT)
    texA = Merge::TexMad.new(pg_src_b, 0.5, 0.0)
    texB = Merge::TexMad.new(pg_src_c, 0.5, 0.0)
    filter.merge.apply(pg_src_a, texA, texB)
  when 12
    passes.to_i.times do
      filter.laplace.apply(pg_src_a, pg_src_b, Laplace::TYPE.values[laplace_weight.to_i])
      swapAB
    end
  when 13
    filter.dog.param.kernel_A = blur_radius * 2
    filter.dog.param.kernel_B = blur_radius * 1
    filter.dog.param.mult  = 2.5
    filter.dog.param.shift = 0.5
    filter.dog.apply(pg_src_a, pg_src_b, pg_src_c)
    swapAB
  when 14
    filter.median.apply(pg_src_a, pg_src_b, Median::TYPE::_3x3_)
    swapAB
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius, gaussblur_sigma)
    end
    filter.sobel.apply(pg_src_a, pg_src_b, Sobel::TYPE::_3x3_HORZ)
    swapAB
  when 15
    filter.median.apply(pg_src_a, pg_src_b, Median::TYPE::_3x3_)
    swapAB
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius, gaussblur_sigma)
    end
    filter.laplace.apply(pg_src_a, pg_src_b, Laplace::TYPE.values[laplace_weight.to_i])
    swapAB
  when 16
    harris.update(pg_src_a)
    # for better contrast, make the image grayscale, so the harris points (red)
    # are  more obvious
    filter.luminance.apply(pg_src_a, pg_src_b)
    swapAB
    harris.render(pg_src_a)
  when 17
    filter.bloom.apply(pg_src_c, pg_src_c, pg_src_a)
  when 18
    # filter.gaussblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius)
    filter.luminance_threshold.apply(pg_src_a, pg_src_a)
  when 19
    filter.luminance_threshold.apply(pg_src_a, pg_src_b)
    # filter.bloom.apply(pg_src_b, pg_src_a)
    filter.bloom.apply(pg_src_b, pg_src_b, pg_src_a)
  when 20
    pg_src_b.begin_draw
    pg_src_b.background(0)
    pg_src_b.no_stroke
    pg_src_b.fill(255)
    pg_src_b.rectMode(CENTER)
    pg_src_b.ellipse(mouse_x, mouse_y, 200, 200)
    pg_src_b.end_draw
    filter.distancetransform.param.FG_mask = [1.0, 1.0, 1.0, 1.0]
    filter.distancetransform.create(pg_voronoi_centers)
    filter.distancetransform.apply(pg_src_a, pg_src_c)
    swapAC
  when 21
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_a, pg_src_a, pg_src_b, blur_radius, gaussblur_sigma)
    end
    filter.luminance.apply(pg_src_a, pg_src_b)
    flowfield.create(pg_src_b)
    flowfield.param.line_col_A = [0, 0, 0, 1.0]
    flowfield.param.line_col_B = [0, 0, 0, 0.1]
    flowfield.param.line_scale = 1.5
    flowfield.param.line_width = 1.0
    flowfield.param.line_spacing = 10
    flowfield.param.line_shading = 0
    flowfield.display_pixel(pg_src_a)
    flowfield.display_lines(pg_src_a)
  when 22
    filter.copy.apply(pg_src_a, tex_a)
    minmax_global.apply(tex_a)
    minmax_global.map(tex_a, tex_a, false)
    filter.copy.apply(tex_a, pg_src_a)
    mima = minmax_global.getVal.getByteTextureData(nil)
    mm_format = "min[%3d %3d %3d %3d] max[%3d %3d %3d %3d]\n"
    puts format(mm_format, mima[0]&0xFF, mima[1]&0xFF, mima[2]&0xFF, mima[3]&0xFF, mima[4]&0xFF, mima[5]&0xFF, mima[6]&0xFF, mima[7]&0xFF)
  end
  # display result
  background(0)
  blend_mode(REPLACE)
  image(pg_src_a, 0, 0)
  blend_mode(BLEND)
  # info
  format_string = 'Image Processing Filter [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, pg_src_a.width, pg_src_a.height, frame_count, frame_rate))
end

def swapAB
  @pg_src_a, @pg_src_b = pg_src_b, pg_src_a
end

def swapAC
  @pg_src_a, @pg_src_c = pg_src_c, pg_src_a
end
