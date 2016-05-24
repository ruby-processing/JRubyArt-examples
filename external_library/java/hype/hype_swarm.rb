# encoding: utf-8
load_library :hype
include_package 'hype'
# Access through Hype namespace
module Hype
  java_import 'hype.extended.behavior.HSwarm'
  java_import 'hype.extended.behavior.HTimer'
  java_import 'hype.extended.behavior.HTween'
  java_import 'hype.extended.colorist.HColorPool'
  java_import 'hype.interfaces.HLocatable'
end

PALETTE = %w(#FFFFFF #F7F7F7 #ECECEC #333333 #0095a8 #00616f #FF3300 #FF6600).freeze
PALETTE2 = %w(#242424 #111111 #ECECEC).freeze
include Hype

attr_reader :swarm, :canvas, :colors, :pool, :tween, :count

def settings
  size(640, 640)
end

def setup
  sketch_title 'Hype Swarm'
  H.init(self)
  @count = 0
  @colors = HColorPool.new(web_to_color_array(PALETTE))
  colors2 = web_to_color_array(PALETTE2)
  H.background(colors2[0])
  H.add(@canvas = HCanvas.new.auto_clear(false).fade(40))
  @swarm = HSwarm.new
                 .speed(4)
                 .turn_ease(0.1)
                 .twitch(15)
                 .idle_goal(width / 2, height / 2)
  @pool = HDrawablePool.new(10)
  pool.auto_add_to_stage
      .add(HRect.new(10).rounding(5))
      .on_create do |obj|
    obj.stroke_weight(2)
       .stroke(colors2[1])
       .fill(colors2[2])
       .loc(rand(100..540), rand(100..540))
       .anchor_at(H::CENTER)
       .rotation(45)
    @tween = HTween.new
                   .target(obj).property(H::LOCATION)
                   .start(obj.x, obj.y)
                   .end(rand(0..width), rand(0..height))
                   .ease(0.01)
                   .spring(0.9)
    on_anim = proc do
      tween.start(obj.x, obj.y)
           .end(rand(100..540), rand(100..540))
           .ease(0.01)
           .spring(0.9)
           .register
    end
    HTimer.new.interval(2_000).callback(&on_anim)
  end
      .request_all
end

def draw
  if count < 100
    swarm.add_target(
      canvas.add(
        HRect.new(8, 2)
             .rounding(4)
             .anchor_at(H::CENTER)
             .no_stroke
             .fill(colors.get_color)
      )
    )
    @count += 1
  end
  H.draw_stage 
  it = swarm.goals.iterator
  while it.has_next
    it.remove
    it.next
  end 
    
  pool.each do |d|
    swarm.add_goal(d.x, d.y)
  end
end
