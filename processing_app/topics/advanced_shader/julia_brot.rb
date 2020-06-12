# frozen_string_literal: true

# From an original sketch by Jonathon Scott (aka jscottpilgrim)
# modified by Martin Prout (aka monkstone) to have a control_panel gui



# Holder for Maximum & Minimum coords
MaxMin = Struct.new(:lox, :hix, :loy, :hiy)


load_library :control_panel
attr_reader :center, :x_center, :scaling, :shaders, :y_center, :zoom
DEFAULT = 4.0

def settings
  size 1000, 1000, P2D
end

def control_update
  @zoom = scaling / width
  @y_range = scaling * height / width
  @center = Vec2D.new(-x_center, y_center)
end

def setup
  sketch_title 'JuliaBrot'
  control_panel do |c|
    c.look_feel 'Nimbus'
    c.title 'Control Panel'
    c.button :reset! # see method below
    c.slider :scaling, 1.0..10.0, DEFAULT
    c.slider :x_center, -3.0..3.0, 0.0
    c.slider :y_center, -3.0..3.0, 0.0
    c.checkbox :hi_res, false
    c.menu :mode, %w[mandelbrot julia julia_loop], 'mandelbrot'
  end
  control_update
  @julia_param = Vec2D.new(0.1994, -0.613)

  # length of julia loop in frames
  @loop_length = 120
  # initialize some parameters
  @line_start = Vec2D.new(0, 0)
  @julia_loop_begin = Vec2D.new(0, 0)
  @julia_loop_end = Vec2D.new(0, 0)
  @loop_time = 0
  @hi_res = false
  @shaders = init_shaders
  reset!
end

def init_shader(name)
  shader = format('%<name>s.glsl', name: name)
  load_shader(data_path(shader)).tap do |loaded|
    loaded.set 'resolution', width.to_f, height.to_f
  end
end

def init_shaders
  %w[MandelbrotDE MandelbrotDE-double JuliaDE JuliaDE-double].map do |shader|
    init_shader(shader)
  end
end

def mandelbrot_draw
  s = @hi_res ? shaders[1] : shaders[0]
  s.set 'center', center.x, center.y
  s.set 'zoom', zoom
  shader s
  rect 0, 0, width, height
  reset_shader
end

def julia_maxmin
  MaxMin.new(
    center.x - scaling / 2.0,
    center.x + scaling / 2.0,
    center.y - @y_range / 2.0,
    center.y + @y_range / 2.0
  )
end

def julia_draw
  s = @hi_res ? shaders[3] : shaders[2]
  s.set 'center', center.x, center.y
  s.set 'zoom', zoom
  s.set 'juliaParam', @julia_param.x, @julia_param.y
  shader s
  rect 0, 0, width, height
  reset_shader
end

def julia_loop_draw
  # calculate julia param with interpolation from julia_loop_begin to julia_loop_end using loop_time
  real_dif = @julia_loop_end.x - @julia_loop_begin.x
  imag_dif = @julia_loop_end.y - @julia_loop_begin.y
  m = Math.sin((TWO_PI / (@loop_length * 2)) * @loop_time)
  real_offset = m * real_dif
  imag_offset = m * imag_dif
  r = @julia_loop_begin.x + real_offset
  i = @julia_loop_begin.y + imag_offset
  @julia_param = Vec2D.new(r, i)
  # increment time for next frame
  @loop_time = @loop_time.succ
  # reset loop time when cycle is complete
  @loop_time = 0 if @loop_time == @loop_length
  julia_draw
end

def draw
  control_update
  case @mode
  when 'mandelbrot'
    mandelbrot_draw
  when 'julia'
    julia_draw
  when 'julia_loop'
    julia_loop_draw
  end
  # show where line for julia loop would be drawn when clicked
  return unless @line_drawing

  stroke 100, 0, 0
  stroke_weight 3
  line @line_start.x, @line_start.y, mouse_x, mouse_y
  no_stroke
end

def reset!
  # reset to standard view mandelbrot
  reset_parameters
  @mode = 'mandelbrot'
  @line_drawing = false
  @line_start = Vec2D.new(0, 0)
  @julia_loop_begin = Vec2D.new(0, 0)
  @julia_loop_end = Vec2D.new(0, 0)
  @loop_time = 0
end

def reset_parameters
  @center = Vec2D.new 0, 0
  @scaling = DEFAULT
  @y_range = DEFAULT * height / width
  @zoom = DEFAULT / width
end

def mouse_clicked
  if @line_drawing
    # select ending point for julia loop
    maxmin = julia_maxmin
    @julia_loop_end = Vec2D.new(
      map1d(mouse_x, (0...width), (maxmin.lox..maxmin.hix)),
      map1d(mouse_y, (0..height), (maxmin.loy..maxmin.hiy))
    )
    @line_drawing = false
    reset_parameters
    @zoom = scaling / width
    @mode = 'julia_loop'
    @loop_time = 0
  else
    if @mode.eql? 'mandelbrot'
      # from mandelbrot use mouse to choose seed(s) for julia set(s)
      if mouse_button == RIGHT
        # start line for julia loop
        @line_drawing = true
        @line_start = Vec2D.new mouse_x, mouse_y
        maxmin = julia_maxmin
        @julia_loop_begin = Vec2D.new(
          map1d(mouse_x, (0...width), (maxmin.lox..maxmin.hix)),
          map1d(mouse_y, (0..height), (maxmin.loy..maxmin.hiy))
        )
      else
        # left click for static julia set
        maxmin = julia_maxmin
        @julia_param = Vec2D.new(
          map1d(mouse_x, (0...width), (maxmin.lox..maxmin.hix)),
          map1d(mouse_y, (0..height), (maxmin.loy..maxmin.hiy))
        )
        reset_parameters
        @mode = 'julia'
      end
    end
  end
end
