#
# Wave Machine Example.
#
# required libraries:
#  - PixelFlow, https://github.com/diwi/PixelFlow
#
#
# Controls:
#
# LMB         ... drag bodies
# LMB + SHIFT ... shoot bullet
# MMB         ... add particles
# RMB         ... remove particles
# 'r'         ... reset
# 't'         ... update/pause physics
# 'f'         ... toggle debug draw
# 'g'         ... toggle DwLiquidFX
#
load_libraries :LiquidFunProcessing, :PixelFlow

# namespace for java libraries
module Liquid
  java_import 'com.thomasdiewald.liquidfun.java.DwWorld'
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwLiquidFX'
  java_import 'org.jbox2d.collision.shapes.PolygonShape'
  java_import 'org.jbox2d.common.Color3f'
  java_import 'org.jbox2d.common.Vec2'
  java_import 'org.jbox2d.dynamics.Body'
  java_import 'org.jbox2d.dynamics.BodyDef'
  java_import 'org.jbox2d.dynamics.BodyType'
  java_import 'org.jbox2d.dynamics.joints.RevoluteJoint'
  java_import 'org.jbox2d.dynamics.joints.RevoluteJointDef'
  java_import 'org.jbox2d.particle.ParticleGroupDef'
  java_import 'org.jbox2d.particle.ParticleType'
end

include Liquid

VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0

attr_reader :m_time, :pg_particles, :world, :pixelflow, :liquidfx
attr_reader :update_physics, :use_debug_draw, :appl_liquid_fx, :m_joint
def settings
  size(VIEWPORT_W, VIEWPORT_H, P2D)
  smooth(8)
end

def setup
  surface.set_location(VIEWPORT_X, VIEWPORT_Y)
  @update_physics = true
  @use_debug_draw = false
  @appl_liquid_fx = true
  @pixelflow = DwPixelFlow.new(self)
  @liquidfx = DwLiquidFX.new(pixelflow)
  @pg_particles = create_graphics(width, height, P2D)
  @m_time = 0
  reset
end

def release
  world.release unless world.nil?
  @world = nil
end

def reset
  # release old resources
  release
  @world = DwWorld.new(self, 20)
  world.transform.set_screen(width, height, 20, width / 2, height / 2)
  #    world.particles.param.falloff_exp1 = 2
  #    world.particles.param.falloff_exp2 = 2
  #    world.particles.param.radius_scale = 3
  param = world.particles.param
  param.falloff_exp1 = 3
  param.falloff_exp2 = 1
  param.radius_scale = 2
  # create scene: rigid bodies, particles, etc ...
  init_scene
end

def draw
  wave if @update_physics
  back_color = 32
  if @use_debug_draw
    canvas = g
    canvas.background(back_color)
    canvas.push_matrix
    world.apply_transform(canvas)
    world.draw_bullet_spawn_track(canvas)
    world.display_debug_draw(canvas)
    canvas.pop_matrix
  else
    canvas = pg_particles
    canvas.begin_draw
    canvas.clear
    canvas.background(back_color, 0)
    world.apply_transform(canvas)
    world.particles.display(canvas, 0)
    canvas.end_draw
    if @appl_liquid_fx
      param = liquidfx.param
      param.base_LoD = 1
      param.base_blur_radius = 2
      param.base_threshold = 0.7
      param.highlight_enabled = true
      param.highlight_LoD = 1
      param.highlight_decay = 0.6
      param.sss_enabled = true
      param.sss_LoD = 3
      param.sss_decay = 0.5
      liquidfx.apply(canvas)
    end
    background(back_color)
    image(canvas, 0, 0)
    push_matrix
    world.apply_transform(g)
    world.bodies.display(g)
    world.drawBulletSpawnTrack(g)
    pop_matrix
  end
  # info
  num_bodies    = world.get_body_count
  num_particles = world.get_particle_count
  title_format = 'Wave Machine | bodies: %d particles: %d fps: %6.2f'
  surface.set_title(format(title_format, num_bodies, num_particles, frame_rate))
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
  when 'g'
    @appl_liquid_fx = !appl_liquid_fx
  end
end

#######################################
# Scene Setup
#######################################

def wave
  @m_time += 1 / 120.0
  m_joint.set_motor_speed(0.1 * cos(m_time) * PI)
  world.update
end

# https://github.com/jbox2d/jbox2d/blob/master/jbox2d-testbed/src/main/java/org/jbox2d/testbed/tests/WaveMachine.java
def init_scene
  bd = BodyDef.new
  ground = world.create_body(bd)
  bd.type = BodyType::DYNAMIC
  bd.allow_sleep = false
  bd.position.set(0.0, 0.0)
  body = world.create_body(bd)
  vessel = create_vessel(body)
  body.create_fixture(vessel, 5.0)
  world.bodies.add(body, true, color(0), true, color(0), 1)
  create_revolute_joint(ground, body)
  world.bodies.add_all
  world.set_particle_radius(0.15)
  world.set_particle_damping(0.6)
  world.create_particle_group(define_particle_group)
  @m_time = 0
end

def create_vessel(body)
  shape = PolygonShape.new
  shape.set_as_box(1, 9.5, Vec2.new(19.0, 0.0), 0.0)
  body.create_fixture(shape, 5.0)
  shape.set_as_box(1, 9.5, Vec2.new(-19.0, 0.0), 0.0)
  body.create_fixture(shape, 5.0)
  shape.set_as_box(20.0, 1, Vec2.new(0.0, 11.0), 0.0)
  body.create_fixture(shape, 5.0)
  shape.set_as_box(20.0, 1, Vec2.new(0.0, -11.0), 0.0)
  shape
end

def define_particle_group
  pd = ParticleGroupDef.new
  pd.flags = ParticleType.b2_waterParticle | ParticleType.b2_viscousParticle
  # pd.set_color(Color3f.new(1, 0.15, 0.05))
  pd.set_color(Color3f.new(0.05, 0.15, 1))
  pd.set_color(Color3f.new(0.15, 1, 0.05))
  shape = PolygonShape.new
  shape.set_as_box(17.0, 9.0, Vec2.new(0.0, 0.0), 0.0)
  pd.shape = shape
  pd
end

def create_revolute_joint(ground, body)
  jd = RevoluteJointDef.new
  jd.bodyA = ground
  jd.bodyB = body
  jd.localAnchorA.set(0.0, 0.0)
  jd.localAnchorB.set(0.0, 0.0)
  jd.referenceAngle = 0.0
  jd.motorSpeed = 0.05 * PI
  jd.maxMotorTorque = 1e7
  jd.enableMotor = true
  @m_joint = world.create_joint(jd)
end
