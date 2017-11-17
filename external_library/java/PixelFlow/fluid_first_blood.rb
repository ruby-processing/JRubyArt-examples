#
# PixelFlow | Copyright (C) 2016-17 Thomas Diewald (www.thomasdiewald.com)
# Translated to JRubyArt by Martin Prout
#
# src  - www.github.com/diwi/PixelFlow
#
# A Processing/Java library for high performance GPU-Computing.
# MIT License: https://opensource.org/licenses/MIT
#
load_libraries :PixelFlow, :controlP5

java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
java_import 'com.thomasdiewald.pixelflow.java.fluid.DwFluid2D'
java_import 'com.thomasdiewald.pixelflow.java.fluid.DwFluidParticleSystem2D'
java_import 'controlP5.Accordion'
java_import 'controlP5.ControlP5'
java_import 'controlP5.Group'
java_import 'controlP5.RadioButton'
java_import 'controlP5.Toggle'
java_import 'controlP5.ControlListener'

include ControlListener

DISPLAY_MODE = %w[Density Temperature Pressure Velocity]
VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0

GUI_W = 200
GUI_X = 20
GUI_Y = 20

# attr_reader :fluidgrid_scale, :fluid, :pg_fluid, :pg_obstacles, :context
attr_reader :display_particles, :particle_system, :display_fluid_texture_mode
attr_reader :display_fluid_textures, :display_fluid_vectors, :fluid, :pg_fluid
attr_reader :pg_obstacles, :context, :fluidgrid_scale, :update_fluid, :cp5
attr_reader :rb_setdisplay_mode, :background_color

def settings
  size(VIEWPORT_W, VIEWPORT_H, P2D)
  smooth(4)
end

def setup
  surface.setLocation(VIEWPORT_X, VIEWPORT_Y)
  @display_particles = false
  @fluidgrid_scale = 1
  # main library context
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  @update_fluid = true
  @display_fluid_textures = true
  @display_fluid_vectors = false
  @display_fluid_texture_mode = 0
  @background_color = 255
  # fluid simulation
  @fluid = DwFluid2D.new(context, VIEWPORT_W, VIEWPORT_H, fluidgrid_scale)

  # particle
  @particle_system = DwFluidParticleSystem2D.new(context, VIEWPORT_W / 3, VIEWPORT_H / 3)

  # interface for adding data to the fluid simulation
  fluid.addCallback_FluiData do |fluid|
    if !cp5.isMouseOver && mouse_pressed?

      vscale = 15
      px     = mouse_x
      py     = height - mouse_y
      vx     = (mouse_x - pmouse_x) * +vscale
      vy     = (mouse_y - pmouse_y) * -vscale
      intensity = 2.0
      temperature = 5.0

      # add impulse: density + velocity
      if mouseButton == LEFT
        radius = 10
        fluid.addDensity(px, py, radius, 1, 0, 0, intensity)
        radius = 3
        fluid.addDensity(px, py, radius, 1, 0.8 ,0.6, intensity)
        radius = 15
        fluid.addVelocity(px, py, radius, vx, vy)
      end

      # add impulse: velocity
      if mouseButton == CENTER
        radius = 10
        fluid.addVelocity(px, py, radius, vx, vy)
      end

      # add impulse: density + temperature
      if mouseButton == RIGHT
        radius = 15
        fluid.addDensity(px, py, radius, 0.9 ,0.9, 0.9, intensity)
        radius = 10
        fluid.addTemperature(px, py, radius, temperature)
      end
    end
  end
  # pgraphics for fluid
  @pg_fluid = create_graphics(VIEWPORT_W, VIEWPORT_H, P2D)
  pg_fluid.smooth(4)

  # pgraphics for obstacles
  @pg_obstacles = create_graphics(VIEWPORT_W, VIEWPORT_H, P2D)
  pg_obstacles.noSmooth
  pg_obstacles.beginDraw
  pg_obstacles.clear
  # some rectangle
  pg_obstacles.rectMode(CENTER)
  pg_obstacles.translate(width / 2, height / 2)
  pg_obstacles.rotate(PI * 0.1)
  pg_obstacles.stroke(192)
  pg_obstacles.strokeWeight(10)
  pg_obstacles.noFill
  pg_obstacles.rect(0, 0, 200, 200)
  # border-obstacle
  pg_obstacles.resetMatrix
  pg_obstacles.rectMode(CORNER)
  pg_obstacles.strokeWeight(20)
  pg_obstacles.stroke(192)
  pg_obstacles.noFill
  pg_obstacles.rect(0, 0, pg_obstacles.width, pg_obstacles.height)
  pg_obstacles.endDraw
  createGUI
  background(background_color)
  frame_rate(600)
end

def draw
  if update_fluid
    fluid.add_obstacles(pg_obstacles)
    fluid.update
    particle_system.update(fluid)
  end
  pg_fluid.begin_draw
  pg_fluid.background(background_color)
  pg_fluid.end_draw
  # render: density (0), temperature (1), pressure (2), velocity (3)
  fluid.renderFluidTextures(pg_fluid, display_fluid_texture_mode) if display_fluid_textures
  # render: velocity vector field
  fluid.renderFluidVectors(pg_fluid, 10) if display_fluid_vectors
  # render: particles 0 ... points, 1 ...sprite texture, 2 ... dynamic points
  particle_system.render(pg_fluid, nil, 2) if display_particles
  # display
  image(pg_fluid, 0, 0)
  image(pg_obstacles, 0, 0)
  # info
  format_string = 'Fluid First Blood [size %d/%d]  [frame %d]  [fps: (%6.2f)]'
  surface.set_title(format(format_string, fluid.fluid_w, fluid.fluid_h, fluid.simulation_step, frame_rate))
end

def resize_up
  fluid.resize(width, height, @fluidgrid_scale -= 1) unless fluidgrid_scale < 2
end

def resize_down
  fluid.resize(width, height, @fluidgrid_scale += 1)
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

def fluid_display_particles(val)
  @display_particles = val != -1
end

def key_released
  case key
  when 'q'
    @display_fluid_textures = !display_fluid_textures
  when 'w'
    @display_fluid_vectors  = !display_fluid_vectors
  when 's'
    # save ControlP5 settings in json format
    cp5.save_properties(data_path('fluid_first_blood.json'))
  end
end

def createGUI
  @cp5 = ControlP5.new(self)
  sx = 100
  sy = 14
  oy = (sy * 1.5).to_i
  ############################################################################
  # GUI - FLUID
  ############################################################################
  group_fluid = cp5.addGroup('fluid')
  group_fluid.setHeight(20).setSize(GUI_W, 300)
  .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180))
  group_fluid.getCaptionLabel.align(CENTER, CENTER)
  px = 10
  py = 15
  cp5.addButton('reset').setGroup(group_fluid)
                        .setSize(80, 18)
                        .setPosition(px, py)
                        .add_listener { reset! }
  cp5.addButton('+').setGroup(group_fluid)
                    .setSize(39, 18)
                    .setPosition(px += 82, py)
                    .add_listener { resize_up } # add listener direct to button
  cp5.addButton('-').setGroup(group_fluid)
                    .setSize(39, 18)
                    .setPosition(px += 41, py)
                    .add_listener { resize_down } # add listener direct to button
  px = 10
  cp5.addSlider('velocity')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += (oy * 1.5).to_i)
     .setRange(0, 1)
     .setValue(0.51)
  cp5.addSlider('density')
     .setGroup(group_fluid).setSize(sx, sy).setPosition(px, py += oy)
     .setRange(0, 1)
     .setValue(0.99)
  cp5.addSlider('temperature')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += oy)
     .setRange(0, 1)
     .setValue(0.5)
  cp5.addSlider('vorticity')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += oy)
     .setRange(0, 1)
     .setValue(0)
  cp5.addSlider('iterations')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += oy)
     .setRange(0, 80)
     .setValue(1)
  cp5.addSlider('timestep')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += oy)
     .setRange(0, 1)
     .setValue(0.125)
  cp5.addSlider('gridscale')
     .setGroup(group_fluid)
     .setSize(sx, sy)
     .setPosition(px, py += oy)
     .setRange(0, 50)
     .setValue(1)
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
  ############################################################################
  # GUI - DISPLAY
  ############################################################################
  group_display = cp5.addGroup('display')
  group_display.setHeight(20)
               .setSize(GUI_W, 50)
               .setBackgroundColor(color(16, 180))
               .setColorBackground(color(16, 180))
  group_display.getCaptionLabel.align(CENTER, CENTER)
  px = 10
  py = 15
  cp5.addSlider('BACKGROUND')
     .setGroup(group_display)
     .setSize(sx,sy)
     .setPosition(px, py)
     .setRange(0, 255)
     .setValue(0)
  cp5.addRadio('fluid_displayParticles')
     .setGroup(group_display)
     .setSize(18, 18)
     .setPosition(px, py += (oy * 1.5).to_i)
     .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
     .addItem('display particles', 0)
     .activate(0)
  ############################################################################
  # GUI - ACCORDION
  ############################################################################
  cp5.addAccordion('acc').setPosition(GUI_X, GUI_Y)
     .setWidth(GUI_W)
     .setSize(GUI_W, height)
     .setCollapseMode(Accordion::MULTI)
     .addItem(group_fluid)
     .addItem(group_display)
     .open(4)
end

def controlEvent(event)
  if event.group?
    case event.group.get_name
    when 'display_mode'
      display_mode(rb_setdisplay_mode.value)
    when 'display_velocity_vectors'
      display_velocity_vectors(event.group.value)
    when 'display_fluid_particles'
      display_fluid_particles(event.group.value)
    end
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
