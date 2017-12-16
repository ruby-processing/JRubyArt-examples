#
# LiquidFunProcessing | Copyright 2017 Thomas Diewald - www.thomasdiewald.com
#
# https://github.com/diwi/LiquidFunProcessing.git
#
# Box2d / LiquidFun Library for Processing.
# MIT License: https:#opensource.org/licenses/MIT
#
load_library :LiquidFunProcessing
java_import 'com.thomasdiewald.liquidfun.java.DwWorld'
java_import 'com.thomasdiewald.liquidfun.java.render.DwParticleRenderGL'
java_import 'com.thomasdiewald.liquidfun.java.render.DwParticleRenderP5'
java_import 'org.jbox2d.collision.shapes.ChainShape'
java_import 'org.jbox2d.collision.shapes.PolygonShape'
java_import 'org.jbox2d.common.Color3f'
java_import 'org.jbox2d.common.Vec2'
java_import 'org.jbox2d.dynamics.Body'
java_import 'org.jbox2d.dynamics.BodyDef'
java_import 'org.jbox2d.particle.ParticleGroupDef'
java_import 'org.jbox2d.particle.ParticleType'

# Simulation of a clash of two big particle-groups.
#
#
# Controls:
#
# 'r'         ... reset
# 't'         ... update/pause physics
# 'f'         ... toggle debug draw
# 'd'         ... display particle renderer type
VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0
attr_reader :world, :update_physics, :use_debug_draw

def settings
  size(VIEWPORT_W, VIEWPORT_H, P2D)
  smooth(8)
end

def setup
  surface.set_location(VIEWPORT_X, VIEWPORT_Y)
  sketch_title 'Liquid fun dambreak particles'
  @update_physics = true
  @use_debug_draw = false
  reset
  frame_rate(120)
end

def release
  return if world.nil?
  world.release
  @world = nil
end

def reset
  # release old resources
  release
  # if false, PShape-Quads are used for particles, instead of openGL points.
  # this replaces the default particle renderer (OpenGL) with an alternative
  # renderer where particles are rendered as PShape-Quads.
  # It renders a bit slower then the OpenGL version and grouped rendering
  # is also not possible.
  DwWorld.INIT_GL_PARTICLES = true
  # create world
  @world = DwWorld.new(self, 18)
  # create scene: rigid bodies, particles, etc ...
  init_scene
end

def draw
  world.update if update_physics
  canvas = g
  canvas.background(32)
  canvas.push_matrix
  world.apply_transform(canvas)
  world.draw_bullet_spawn_track(canvas)
  if use_debug_draw
    world.display_debug_draw(canvas)
    # DwDebugDraw.display(canvas, world)
  else
    world.display(canvas)
  end
  canvas.pop_matrix
  # info
  num_bodies = world.get_body_count
  num_particles = world.get_particle_count
  string_format = 'liquid fun [bodies: %d] [particles: %d] [fps: %6.2f]'
  txt_fps = format(string_format, num_bodies, num_particles, frame_rate)
  surface.set_title(txt_fps)
end

def particle_renderer(particles)
  return 'GL Particle Renderer' if particles.java_kind_of? DwParticleRenderGL
  return 'P5 Particle Renderer' if particles.java_kind_of? DwParticleRenderP5
  'Something wrong with particle renderer'
end

#######################################
# User Interaction
#######################################
def key_released
  case key
  when 't'
    @update_physics = !update_physics
  when 'r'
    reset
  when 'f'
    @use_debug_draw = !use_debug_draw
  when 'd'
    puts particle_renderer(world.particles)
  end
end

###############init_scene########################
# Scene Setup
# https://github.com/jbox2d/jbox2d/blob/master/jbox2d-testbed/src/main/java/org/jbox2d/testbed/tests/DamBreak.java
#######################################
def init_scene
  dimx = world.transform.box2d_dimx
  dimy = world.transform.box2d_dimy
  dimxh = dimx / 2
  dimyh = dimy / 2
  bd = BodyDef.new
  ground = world.create_body(bd)
  shape = ChainShape.new
  vertices = [
    Vec2.new(-dimxh, 0),
    Vec2.new(dimxh, 0),
    Vec2.new(dimxh, dimy),
    Vec2.new(-dimxh, dimy)
  ]
  shape.create_loop(vertices, 4)
  ground.create_fixture(shape, 0.0)
  world.bodies.add(ground, false, color(0), true, color(0), 1)
  pshape = PolygonShape.new
  pd = ParticleGroupDef.new
  pd.flags = 0
  sx = dimxh * 0.25
  sy = dimyh * 0.95
  pshape.set_as_box(sx, sy, Vec2.new(-dimxh / 2, dimyh), 0)
  pd.shape = pshape
  pd.set_color(Color3f.new(0.00, 0.2, 1))
  world.create_particle_group(pd)
  pshape.set_as_box(sx, sy, Vec2.new(+dimxh / 2, dimyh), 0)
  pd.shape = pshape
  pd.set_color(Color3f.new(1.00, 0.2, 0.00))
  world.create_particle_group(pd)
end
