load_libraries :PixelFlow, :controlP5
java_import 'controlP5.Accordion'
java_import 'controlP5.ControlP5'
java_import 'controlP5.Group'
java_import 'controlP5.RadioButton'
java_import 'controlP5.Toggle'
java_import 'controlP5.ControlListener'

include ControlListener

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
    1 / 9.0, 1 / 9.0, 1 / 9.0,
  ],
  [ # lowpass: gauss-blur
    1 / 16.0, 2 / 16.0, 1 / 16.0,
    2 / 16.0, 4 / 16.0, 2 / 16.0,
    1 / 16.0, 2 / 16.0, 1 / 16.0,
  ],
  [ # sharpen highpass: laplace
    0,-1, 0,
    -1, 5,-1,
    0,-1, 0
  ],
  [ # sharpen highpass: laplace
    -1,-1,-1,
    -1, 9,-1,
    -1,-1,-1,
  ],
  [ # sharpen highpass: laplace
    -1,-2,-1,
    -2,13,-2,
    -1,-2,-1,
  ],
  [ # edges 1
    +0,+1,+0,
    +1,-4,+1,
    +0,+1,+0
  ],
  [ # edges 2
    +1,+1,+1,
    +1,-8,+1,
    +1,+1,+1
  ],
  [ # gradient: sobel horizontal
    +1, 0,-1,
    +2, 0,-2,
    +1, 0,-1,
  ],
  [ # gradient: sobel vertical
    +1,+2,+1,
    0, 0, 0,
    -1,-2,-1,
  ],
  [ # gradient: sobel diagonal TL-BR
    +2, 1 ,0,
    +1, 0,-1,
    +0,-1,-2,
  ],
  [  # gradient: sobel diagonal TR-BL
    0,-1,-2,
    +1, 0,-1,
    +2,+1, 0,
  ],
  [  # emboss / structure / relief
    0,-1,-2,
    +1, 1,-1,
    +2,+1, 0,
  ],
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

attr_reader :hide, :context, :flowfield, :minmax_global, :harris, :filter
attr_reader :tex_A, :pg_src_A, :pg_src_B, :pg_src_C, :cp5, :img, :laplace_weight
attr_reader :pg_voronoi_centers, :show_geom, :show_image, :animations, :passes
attr_reader :rs, :vel, :pos, :panel, :filters, :blur_radius, :conv_kernel_idx

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
  @pg_src_A = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_A.smooth(8)
  @pg_src_B = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_B.smooth(8)
  pg_src_B.begin_draw
  pg_src_B.clear
  pg_src_B.end_draw
  @pg_src_C = create_graphics(VIEW_WIDTH, VIEW_HEIGHT, P2D)
  pg_src_C.smooth(8)
  @tex_A = DwGLTexture.new
  tex_A.resize(context, GL::GL_RGBA8, VIEW_WIDTH, VIEW_HEIGHT, GL::GL_RGBA, GL::GL_UNSIGNED_BYTE, GL::GL_NEAREST, 4, 1)
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
    pg_voronoi_centers.point(px + 0.5,  py + 0.5)
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
    @panel = c
  end
  # frame_rate(60)
  frame_rate(1000)
end

def draw
  unless hide
    @hide = true
    panel.set_visible(hide)
  end
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
  pg_src_C.begin_draw
  pg_src_C.rect_mode(CENTER)
  pg_src_C.background(0)
  if show_geom
    pg_src_C.stroke_weight(1)
    pg_src_C.stroke(0, 255, 0)
    pg_src_C.line(w / 2, 0, w / 2, h)
    pg_src_C.line(0, h / 2, w, h / 2)
    pg_src_C.line(0, 0, w, h)
    pg_src_C.line(w, 0, 0, h)
    pg_src_C.stroke_weight(1)
    pg_src_C.stroke(0, 255, 0)
    pg_src_C.no_fill
    pg_src_C.ellipse(w / 2, h / 2, 150, 150)
    pg_src_C.stroke_weight(1)
    pg_src_C.stroke(0, 255, 0)
    pg_src_C.no_fill
    pg_src_C.rect(w / 2, h / 2, 300, 300)
    srand(1)
    PEPPER.times do
      px = rand(20..w - 20)
      py = rand(20..h - 20)
      pg_src_C.no_stroke
      pg_src_C.fill(0, 255, 0)
      pg_src_C.rect(px, py, 2, 2)
    end
  end
  pg_src_C.end_draw
  # update input image
  pg_src_A.begin_draw
  pg_src_A.rect_mode(CENTER)
  pg_src_A.clear
  pg_src_A.background(255)
  if show_image
    pg_src_A.image(img, 0, 0)
  end
  if show_geom
    pg_src_A.stroke_weight(1)
    pg_src_A.stroke(0)
    pg_src_A.line(w / 2, 0, w / 2, h)
    pg_src_A.line(0, h / 2, w, h / 2)
    pg_src_A.line(0, 0, w, h)
    pg_src_A.line(w, 0, 0, h)
    pg_src_A.stroke_weight(1)
    pg_src_A.stroke(0)
    pg_src_A.no_fill
    pg_src_A.ellipse(w / 2, h / 2, 150, 150)
    pg_src_A.stroke_weight(1)
    pg_src_A.stroke(0)
    pg_src_A.no_fill
    pg_src_A.rect(w / 2, h / 2, 300, 300)
    srand(1)
    PEPPER.times do
      px = rand(20..w - 20)
      py = rand(20..h - 20)
      pg_src_A.no_stroke
      pg_src_A.fill(0)
      pg_src_A.rect(px, py, 1, 1)
    end
  end
  if animations
    # moving rectangle
    pg_src_A.fill(100, 175, 255)
    pg_src_A.rect(pos.x, pos.y, rs, rs)
    # mouse-driven ellipse
    pg_src_A.fill(255, 150, 0)
    pg_src_A.no_stroke
    pg_src_A.ellipse(mouse_x, mouse_y, 100, 100)
  end
  pg_src_A.end_draw
  # apply filters
  case(current)
  when 0
    filter.luminance.apply(pg_src_A, pg_src_B)
    swapAB
  when 1
    passes.to_i.times do
      filter.boxblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius)
    end
  when 2
    passes.to_i.times do
      filter.summedareatable.setFormat(SummedAreaTable::InternalFormat::RGBA32F)
      filter.summedareatable.create(pg_src_A)
      filter.summedareatable.apply(pg_src_A, blur_radius)
    end
  when 3
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius, gaussblur_sigma)
    end
  when 4
    filter.binomial.apply(pg_src_A, pg_src_A, pg_src_B, BinomialBlur::TYPE::_15x15)
  when 5
    passes.to_i.times do
      filter.bilateral.apply(pg_src_A, pg_src_B, BILATERAL_RADIUS, BILATERAL_SIGMA_COLOR, BILATERAL_SIGMA_SPACE)
      swapAB
    end
  when 6
    passes.to_i.times do
      filter.convolution.apply(pg_src_A, pg_src_B, KERNEL[convolution_kernel_index].to_java(:float))
      swapAB
    end
  when 7
    filter.median.apply(pg_src_A, pg_src_B, Median::TYPE::_3x3_)
    swapAB
  when 8
    passes.to_i.times do
      filter.median.apply(pg_src_A, pg_src_B, Median::TYPE::_5x5_)
      swapAB
    end
  when 9
    filter.sobel.apply(pg_src_A, pg_src_B, Sobel::TYPE::_3x3_HORZ)
    swapAB
  when 10
    filter.sobel.apply(pg_src_A, pg_src_B, Sobel::TYPE::_3x3_VERT)
    swapAB
  when 11
    filter.sobel.apply(pg_src_A, pg_src_B, Sobel::TYPE::_3x3_HORZ)
    filter.sobel.apply(pg_src_A, pg_src_B, Sobel::TYPE::_3x3_VERT)
    texA = Merge::TexMad.new(pg_src_B, 0.5, 0.0)
    texB = Merge::TexMad.new(pg_src_C, 0.5, 0.0)
    filter.merge.apply(pg_src_A, texA, texB)
  when 12
    passes.to_i.times do
      filter.laplace.apply(pg_src_A, pg_src_B, Laplace::TYPE.values[laplace_weight.to_i])
      swapAB
    end
  when 13
    filter.dog.param.kernel_A = blur_radius * 2
    filter.dog.param.kernel_B = blur_radius * 1
    filter.dog.param.mult  = 2.5
    filter.dog.param.shift = 0.5
    filter.dog.apply(pg_src_A, pg_src_B, pg_src_C)
    swapAB
  when 14
    filter.median.apply(pg_src_A, pg_src_B, Median::TYPE::_3x3_)
    swapAB
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius, gaussblur_sigma)
    end
    filter.sobel.apply(pg_src_A, pg_src_B, Sobel::TYPE::_3x3_HORZ)
    swapAB
  when 15
    filter.median.apply(pg_src_A, pg_src_B, Median::TYPE::_3x3_)
    swapAB
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius, gaussblur_sigma)
    end
    filter.laplace.apply(pg_src_A, pg_src_B, Laplace::TYPE.values[laplace_weight.to_i])
    swapAB
  when 16
    harris.update(pg_src_A)
    # for better contrast, make the image grayscale, so the harris points (red)
    # are  more obvious
    filter.luminance.apply(pg_src_A, pg_src_B)
    swapAB
    harris.render(pg_src_A)
  when 17
    filter.bloom.apply(pg_src_C, pg_src_C, pg_src_A)
  when 18
    # filter.gaussblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius)
    filter.luminance_threshold.apply(pg_src_A, pg_src_A)
  when 19
    filter.luminance_threshold.apply(pg_src_A, pg_src_B)
    # filter.bloom.apply(pg_src_B, pg_src_A)
    filter.bloom.apply(pg_src_B, pg_src_B, pg_src_A)
  when 20
    pg_src_B.begin_draw
    pg_src_B.background(0)
    pg_src_B.no_stroke
    pg_src_B.fill(255)
    pg_src_B.rectMode(CENTER)
    pg_src_B.ellipse(mouse_x, mouse_y, 200, 200)
    pg_src_B.end_draw
    filter.distancetransform.param.FG_mask = [1.0, 1.0, 1.0, 1.0]
    filter.distancetransform.create(pg_voronoi_centers)
    filter.distancetransform.apply(pg_src_A, pg_src_C)
    swapAC
  when 21
    passes.to_i.times do
      filter.gaussblur.apply(pg_src_A, pg_src_A, pg_src_B, blur_radius, gaussblur_sigma)
    end
    filter.luminance.apply(pg_src_A, pg_src_B)
    flowfield.create(pg_src_B)
    flowfield.param.line_col_A = [0, 0, 0, 1.0]
    flowfield.param.line_col_B = [0, 0, 0, 0.1]
    flowfield.param.line_scale = 1.5
    flowfield.param.line_width = 1.0
    flowfield.param.line_spacing = 10
    flowfield.param.line_shading = 0
    flowfield.display_pixel(pg_src_A)
    flowfield.display_lines(pg_src_A)
  when 22
    filter.copy.apply(pg_src_A, tex_A)
    minmax_global.apply(tex_A)
    minmax_global.map(tex_A, tex_A, false)
    filter.copy.apply(tex_A, pg_src_A)
    mima = minmax_global.getVal.getByteTextureData(nil)
    mm_format = "min[%3d %3d %3d %3d] max[%3d %3d %3d %3d]\n"
    puts format(mm_format, mima[0]&0xFF, mima[1]&0xFF, mima[2]&0xFF, mima[3]&0xFF, mima[4]&0xFF, mima[5]&0xFF, mima[6]&0xFF, mima[7]&0xFF)
  end
  # display result
  background(0)
  blend_mode(REPLACE)
  image(pg_src_A, 0, 0)
  blend_mode(BLEND)
  # info
  format_string = 'Image Processing Filter [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, pg_src_A.width, pg_src_A.height, frame_count, frame_rate))
end

def swapAB
  @pg_src_A, @pg_src_B = pg_src_B, pg_src_A
end

def swapAC
  @pg_src_A, @pg_src_C = pg_src_C, pg_src_A
end

def createGUI
  @cp5 = ControlP5.new(self)
  sx = 100
  sy = 14
  oy = (sy * 1.5).to_i
  ######################################
  # GUI - FLUID
  ######################################
  group_fluid = cp5.add_group('fluid')
  group_fluid.set_height(20)
             .set_size(GUI_W, 300)
             .set_background_color(color(16, 180))
             .set_color_background(color(16, 180))
  group_fluid.get_caption_label.align(CENTER, CENTER)
  px = 10
  py = 15
  cp5.add_button('reset')
     .set_group(group_fluid)
     .set_size(80, 18)
     .set_position(px, py)
     .add_listener { reset! } # add listener direct to button
  cp5.add_button('+')
     .set_group(group_fluid)
     .set_size(39, 18)
     .set_position(px += 82, py)
     .add_listener { resize_up } # add listener direct to button
  cp5.add_button('-')
     .set_group(group_fluid)
     .set_size(39, 18)
     .set_position(px += 41, py)
     .add_listener { resize_down } # add listener direct to button
  px = 10
  cp5.add_slider('velocity')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += (oy*1.5).to_i)
     .set_range(0, 1)
     .set_value(1.0)
  cp5.add_slider('density')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += oy)
     .set_range(0, 1)
     .set_value(0.99)
  cp5.add_slider('temperature')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += oy)
     .set_range(0, 1)
     .set_value(0.8)
  cp5.add_slider('vorticity')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += oy)
     .set_range(0, 1)
     .set_value(0.1)
  cp5.add_slider('iterations')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += oy)
     .set_range(0, 80)
     .set_value(40)
  cp5.add_slider('timestep')
     .set_group(group_fluid).set_size(sx, sy).set_position(px, py += oy)
     .set_range(0, 1)
     .set_value(0.125)
  cp5.add_slider('gridscale')
     .set_group(group_fluid)
     .set_size(sx, sy)
     .set_position(px, py += oy)
     .set_range(0, 50)
     .set_value(1)
     @rb_setdisplay_mode = cp5.add_radio('display_mode')
                             .set_group(group_fluid)
                             .set_size(80, 18)
                             .set_position(px, py += (oy*1.5).to_i)
                             .set_spacing_column(2)
                             .set_spacing_row(2)
                             .set_items_per_row(2)
  DISPLAY_MODE.each_with_index do |item, i|
    rb_setdisplay_mode.add_item item, i
  end
  rb_setdisplay_mode.get_items.each do |toggle|
    toggle.get_caption_label.alignX(CENTER)
  end
  cp5.add_radio('display_velocity_vectors')
     .set_group(group_fluid)
     .set_size(18,18)
     .set_position(px, py += (oy*2.5).to_i)
     .set_spacing_column(2)
     .set_spacing_row(2)
     .set_items_per_row(1)
     .add_item('Velocity Vectors', 0)
     #.activate(display_fluid_vectors ? 0 : 2)
  ##########################################
  # GUI - DISPLAY
  ##########################################
  group_display = cp5.add_group('display')
  group_display.set_height(20)
               .set_size(GUI_W, 50)
               .set_background_color(color(16, 180))
               .set_color_background(color(16, 180))
  group_display.get_caption_label.align(CENTER, CENTER)
  px = 10
  py = 15
  cp5.add_slider('background')
     .set_group(group_display)
     .set_size(sx,sy)
     .set_position(px, py)
     .set_range(0, 255)
     .set_value(0)
  ##########################################
  # GUI - ACCORDION
  ##########################################
  cp5.addAccordion('acc').set_position(GUI_X, GUI_Y)
                         .set_width(GUI_W)
                         .set_size(GUI_W, height)
                         .set_collapse_mode(Accordion::MULTI)
                         .add_item(group_fluid)
                         .add_item(group_display)
                         .open(4)
end

def controlEvent(event)
  if event.group?
    display_mode(rb_setdisplay_mode.value) if event.group.get_name == 'display_mode'
    display_velocity_vectors(event.group.value) if event.group.get_name == 'display_velocity_vectors'
  elsif event.controller?
    case event.controller.get_name
    when 'gridscale'
      @fluidgrid_scale = event.controller.value.to_i
    when 'velocity'
      fluid.param.dissipation_velocity = event.controller.value
    when 'background'
      @background_color = event.controller.value
    when 'temperature'
      fluid.param.dissipation_temperature = event.controller.value
    when 'timestep'
      fluid.param.timestep = event.controller.value
    when 'iterations'
      fluid.param.num_jacobi_projection = event.controller.value
    when 'density'
      fluid.param.dissipation_density = event.controller.value
    when 'vorticity'
      fluid.param.vorticity = event.controller.value
    end
  end
end
