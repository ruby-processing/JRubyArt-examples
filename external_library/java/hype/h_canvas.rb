# encoding: utf-8
# Using a simplified scanline shader, this example demonstrates how to apply
# a PShader to an HCanvas object.
#
# In the two swarms on screen, half of them have scanlines. These are the
# drawables that are children of the canvas. The scanline shader is directly
# applied to the HCanvas and does not affect the drawables on the stage.
#
# Set the HCanvas renderer to P2D or P3D when using HShaders
load_library :hype
include_package 'hype'
# Access through Hype namespace
module Hype
  java_import 'hype.extended.colorist.HColorPool'
  java_import 'hype.extended.behavior.HTimer'
  java_import 'hype.extended.behavior.HSwarm'
end

attr_reader :my_shader, :swarm, :timer
PALETTE = %w(#FFFFFF #F7F7F7 #ECECEC #333333 #0095a8 #00616f #FF3300 #FF6600).freeze

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'Scanlines GLSL sketch'
  H.init(self)
  H.background(color('#000000'))
  @my_shader = load_shader('scanlines.glsl')
  my_shader.set('resolution', 1.0, 1.0)
  my_shader.set('screenres', width.to_f, height.to_f)
  my_shader.set('time', millis / 1000.0)
  colors = Hype::HColorPool.new(web_to_color_array(PALETTE))
  canvas_shader = H.add(HCanvas.new(P3D)
                   .auto_clear(true)
                   .shader(my_shader))
                   .to_java(Java::Hype::HCanvas)
  swarm = Hype::HSwarm.new.add_goal(H.mouse).speed(5).turn_ease(0.05).twitch(20)
  pool1 = HDrawablePool.new(20)
  pool1.auto_add_to_stage
       .add(HRect.new.rounding(4))
       .on_create do |obj|
    obj.size(rand(50..100))
     .fill(colors.get_color)
     .no_stroke
     .loc(width / 2, height / 2)
     .anchor_at(H::CENTER)
    swarm.add_target(obj)
  end
  pool2 = HDrawablePool.new(20)
  pool2.auto_parent(canvas_shader)
       .add(HRect.new.rounding(4))
       .on_create do |obj|
    obj.size(rand(50..100))
       .fill(colors.get_color)
       .no_stroke
       .loc(width / 2, height / 2)
       .anchor_at(H::CENTER)
    swarm.add_target(obj)
  end
  @timer = Hype::HTimer.new
                       .num_cycles(pool1.num_active)
                       .interval(250)
                       .callback do
    pool1.request
    pool2.request
  end
end

def draw
  H.draw_stage
  my_shader.set('time', millis / 1000.0)
end
