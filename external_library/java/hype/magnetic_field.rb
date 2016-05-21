# encoding: utf-8
load_library :hype
include_package 'hype'
# Use Hype namespace
module Hype
  java_import 'hype.extended.layout.HGridLayout'
  java_import 'hype.extended.behavior.HMagneticField'
  java_import 'hype.extended.behavior.HSwarm'
end

attr_reader :pool, :pool_swarm, :field, :swarm
NUM_MAGNETS = 10

def settings
  size(640, 640)
end

def setup
  sketch_title 'Magnetic Field'
  H.init(self)
  H.background(color('#000000'))
  @field = Hype::HMagneticField.new
  NUM_MAGNETS.times do
    if rand > 0.5
      # x, y, north polarity / strength =  3 / repel
      field.add_pole(rand(0..width), rand(0..height), 3)
    else
      # x, y, south polarity / strength = -3 / attract
      field.add_pole(rand(0..width), rand(0..height), -3)
    end
  end

  @pool = HDrawablePool.new(2_500)
  pool.auto_add_to_stage
      .add(HShape.new('arrow.svg').enable_style(false).anchor_at(H::CENTER))
      .layout(Hype::HGridLayout.new.start_x(-60).start_y(-60).spacing(16, 16).cols(50))
      .on_create do |obj|
        obj.no_stroke.anchor(-20, -20)
        field.add_target(obj)
      end
      .requestAll

  @swarm = Hype::HSwarm.new.add_goal(width / 2, height / 2).speed(7).turn_ease(0.03).twitch(20)
  @pool_swarm = HDrawablePool.new(NUM_MAGNETS)
  pool_swarm.auto_add_to_stage
            .add(HRect.new(5))
            .on_create do |obj|
              obj.no_stroke.no_fill.loc(rand(0..width), rand(0..width)).visibility(false)
              swarm.add_target(obj)
            end
            .requestAll
end

def draw
  pool_swarm.each_with_index do |d, i|
    p = field.pole(i)
    p.x = d.x
    p.y = d.y
  end
  H.draw_stage
end
