#
# PixelFlow | Copyright (C) 2016-17 Thomas Diewald (www.thomasdiewald.com)
# Translated to propane by Martin Prout
#
# src  - www.github.com/diwi/PixelFlow
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
load_libraries :PixelFlow, :controlP5

java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.fluid.DwFluid2D'
java_import 'controlP5.Accordion'
java_import 'controlP5.ControlP5'
java_import 'controlP5.Group'
java_import 'controlP5.RadioButton'
java_import 'controlP5.Toggle'
java_import 'controlP5.ControlListener'

include ControlListener

DISPLAY_MODE = %w[Density Temperature Pressure Velocity]

# This example shows a very basic fluid simulation setup.
# Multiple emitters add velocity/temperature/density each iteration.
# Obstacles are added at startup, by just drawing into a usual object.
# The same way, obstacles can be added/removed dynamically.
#
# additionally some locations add temperature to the scene, to show how
# buoyancy works.
#
#
# controls:
#
# LMB: add Density + Velocity
# MMB: draw obstacles
# RMB: clear obstacles

VIEWPORT_W = 800
VIEWPORT_H = 800
GUI_X = 20
GUI_Y = 20
GUI_W = 200

attr_reader :fluid, :obstacle_painter, :pg_fluid, :pg_obstacles, :group_fluid
attr_reader :update_fluid, :display_fluid_textures, :display_fluid_vectors
attr_reader :display_fluid_texture_mode, :cp5, :fluidgrid_scale, :iterations
attr_reader :mouse_input, :rb_setdisplay_mode, :background_color

def settings
  size(VIEWPORT_W, VIEWPORT_H, P2D)
  smooth(2)
end

def setup
  @update_fluid               = true
  @display_fluid_textures     = true
  @display_fluid_vectors      = false
  @display_fluid_texture_mode = 0
  @background_color = 0
  # main library context
  context = DwPixelFlow.new(self)
  context.print
  context.printGL
  @fluidgrid_scale = 1
  @GUI_W = 200
  @GUI_X = 20
  @GUI_Y = 20

  # fluid simulation
  @fluid = DwFluid2D.new(context, VIEWPORT_W, VIEWPORT_H, fluidgrid_scale)
  # interface for adding data to the fluid simulation
  fluid.addCallback_FluiData do
   # add impulse: density + temperature
    intensity = 1.0
    px = 1 * width / 3
    py = 0
    radius = 100
    r = 0.0
    g = 0.3
    b = 1.0
    fluid.add_density(px, py, radius, r, g, b, intensity)
    if (fluid.simulation_step % 200).zero?
      temperature = 50.0
      fluid.addTemperature(px, py, radius, temperature)
    end
    # add impulse: density + temperature
    animator = sin(fluid.simulation_step * 0.01)
    intensity = 1.0
    px = 2 * width / 3.0
    py = 150
    radius = 50
    r = 1.0
    g = 0.0
    b = 0.3
    fluid.add_density(px, py, radius, r, g, b, intensity)
    temperature = animator * 20.0
    fluid.addTemperature(px, py, radius, temperature)
    # add impulse: density
    px = 1 * width / 3.0
    py = height - 2 * height / 3.0
    radius = 50.5
    r = g = b = 64  / 255.0
    intensity = 1.0
    fluid.add_density(px, py, radius, r, g, b, intensity, 3.0)
    # add impulse: density + velocity
    if mouse_input && mouse_button == LEFT
      radius = 15
      vscale = 15
      px     = mouse_x
      py     = height-mouse_y
      vx     = (mouse_x - pmouse_x) * +vscale
      vy     = (mouse_y - pmouse_y) * -vscale
      fluid.add_density(px, py, radius, 0.25, 0.0, 0.1, 1.0)
      fluid.add_velocity(px, py, radius, vx, vy)
    end
  end
  # pgraphics for fluid
  @pg_fluid = create_graphics(VIEWPORT_W, VIEWPORT_H, P2D)
  pg_fluid.smooth(4)
  pg_fluid.begin_draw
  pg_fluid.background(background_color)
  pg_fluid.end_draw
  # pgraphics for obstacles
  @pg_obstacles = create_graphics(VIEWPORT_W, VIEWPORT_H, P2D)
  pg_obstacles.smooth(0)
  pg_obstacles.begin_draw
  pg_obstacles.clear
  # circle-obstacles
  pg_obstacles.stroke_weight(10)
  pg_obstacles.no_fill
  pg_obstacles.no_stroke
  pg_obstacles.fill(64)
  radius = 100
  pg_obstacles.ellipse(1 * width / 3.0,  2 * height / 3.0, radius, radius)
  radius = 150
  pg_obstacles.ellipse(2 * width / 3.0,  2 * height / 4.0, radius, radius)
  radius = 200
  pg_obstacles.stroke(64)
  pg_obstacles.stroke_weight(10)
  pg_obstacles.no_fill
  pg_obstacles.ellipse(1 * width / 2.0,  1 * height / 4.0, radius, radius)
  # border-obstacle
  pg_obstacles.stroke_weight(20)
  pg_obstacles.stroke(64)
  pg_obstacles.no_fill
  pg_obstacles.rect(0, 0, pg_obstacles.width, pg_obstacles.height)
  pg_obstacles.end_draw
  createGUI
  # class, that manages interactive drawing (adding/removing) of obstacles
  @obstacle_painter = ObstaclePainter.new(pg_obstacles)
  @mouse_input = !cp5.is_mouse_over && mouse_pressed? && !obstacle_painter.drawing?
  frame_rate(60)
end

def draw
  # update simulation
  if update_fluid
    fluid.addObstacles(pg_obstacles)
    fluid.update
  end
  # clear render target
  pg_fluid.begin_draw
  pg_fluid.background(background_color)
  pg_fluid.end_draw
  # render fluid stuff
  if display_fluid_textures
    # render: density (0), temperature (1), pressure (2), velocity (3)
    fluid.renderFluidTextures(pg_fluid, display_fluid_texture_mode)
  end
  # render: velocity vector field
  fluid.renderFluidVectors(pg_fluid, 10) if display_fluid_vectors
  # display
  image(pg_fluid, 0, 0)
  image(pg_obstacles, 0, 0)
  obstacle_painter.display_brush(g)
  # info
  format_string = 'Fluid Basic [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(
    format(
      format_string,
      fluid.fluid_w,
      fluid.fluid_h,
      fluid.simulation_step,
      frame_rate
      )
    )
end

def mouse_pressed
  obstacle_painter.begin_draw(1) if mouse_button == CENTER # add obstacles
  obstacle_painter.begin_draw(2) if mouse_button == RIGHT # remove obstacles
end

def mouse_dragged
  obstacle_painter.draw
end

def mouse_released
  obstacle_painter.end_draw
end

def resize_up
  @fluidgrid_scale -= 1 unless fluidgrid_scale < 2
  fluid.resize(width, height, fluidgrid_scale)
end

def resize_down
  @fluidgrid_scale += 1
  fluid.resize(width, height, fluidgrid_scale)
end

def reset!
  fluid.reset
end

def toggle_pause
  @update_fluid = !update_fluid
end

def display_mode(val)
  @display_fluid_texture_mode = val
  @display_fluid_textures = display_fluid_texture_mode != -1
end

def display_velocity_vectors(val)
  @display_fluid_vectors = val != -1
end

def key_released
  case key
  when 'p'
    toggle_pause # pause / unpause simulation
  when 'r'
    reset!
  when 's'
    # save ControlP5 settings in json format
    cp5.save_properties(data_path('fluid_basic.json'))
  end
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
    display_mode(rb_setdisplay_mode.get_value) if event.get_group.get_name == 'display_mode'
    display_velocity_vectors(event.get_group.get_value) if event.get_group.get_name == 'display_velocity_vectors'
  elsif event.controller?
    case event.get_controller.get_name
    when 'gridscale'
      @fluidgrid_scale = event.get_controller.get_value.to_i
    when 'velocity'
      fluid.param.dissipation_velocity = event.get_controller.get_value
    when 'background'
      @background_color = event.get_controller.get_value
    when 'temperature'
      fluid.param.dissipation_temperature = event.get_controller.get_value
    when 'timestep'
      fluid.param.timestep = event.get_controller.get_value
    when 'iterations'
      fluid.param.num_jacobi_projection = event.get_controller.get_value
    when 'density'
      fluid.param.dissipation_density = event.get_controller.get_value
    when 'vorticity'
      fluid.param.vorticity = event.get_controller.get_value
    end
  end
end

class ObstaclePainter
  include Processing::Proxy
  # 0 ... not drawing
  # 1 ... adding obstacles
  # 2 ... removing obstacles
  attr_reader :pg, :draw_mode, :size_paint, :size_clear, :shading
  attr_reader :paint_x, :paint_y, :clear_x, :clear_y

  def initialize(pg)
    @pg = pg
    @draw_mode = 0
    @size_paint = 15
    @size_clear = size_paint * 2.5
    @shading = 64
  end

  def begin_draw(mode)
    @paint_x = mouse_x
    @paint_y = mouse_y
    @draw_mode = mode
    if mode == 1
      pg.begin_draw
      pg.blend_mode(REPLACE)
      pg.no_stroke
      pg.fill(shading)
      pg.ellipse(mouse_x, mouse_y, size_paint, size_paint)
      pg.end_draw
    end
    clear(mouse_x, mouse_y) if mode == 2
  end

  def drawing?
    !draw_mode.zero?
  end

  def draw
    @paint_x = mouse_x
    @paint_y = mouse_y
    if draw_mode == 1
      pg.begin_draw
      pg.blend_mode(REPLACE)
      pg.stroke_weight(size_paint)
      pg.stroke(shading)
      pg.line(mouse_x, mouse_y, pmouse_x, pmouse_y)
      pg.end_draw
    end
    clear(mouse_x, mouse_y) if draw_mode == 2
  end

  def end_draw
    @draw_mode = 0
  end

  def clear(x, y)
    @clear_x = x
    @clear_y = y
    pg.begin_draw
    pg.blend_mode(REPLACE)
    pg.no_stroke
    pg.fill(0, 0)
    pg.ellipse(x, y, size_clear, size_clear)
    pg.end_draw
  end

  def display_brush(dst)
    if draw_mode == 1
      dst.stroke_weight(1)
      dst.stroke(0)
      dst.fill(200, 50)
      dst.ellipse(paint_x, paint_y, size_paint, size_paint)
    elsif draw_mode == 2
      dst.stroke_weight(1)
      dst.stroke(200)
      dst.fill(200, 100)
      dst.ellipse(clear_x, clear_y, size_clear, size_clear)
    end
  end
end
