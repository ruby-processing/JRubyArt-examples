# contributed by monkstone

require 'cf3'

def setup_the_creature
  @creature = ContextFree.define do

    shape :start do
      rot = 0
      split do
        11.times do               # 11 times increment rotation by 30 degrees
          legs rotation: rot
          rot += 30
          rewind                  # rewind context
        end
        legs rotation: 360
      end
    end

    shape :legs do
      circle hue:  54, saturation: 0.5, brightness: 1.0
      legs y: 0.1, size: 0.96
    end

    shape :legs, 0.01 do
      circle
      split do
        legs rotation: 3
        rewind
        legs rotation: -3
      end
    end

  end
end

def settings
  size 600, 600
end

def setup
  sketch_title 'Creature'
  setup_the_creature
  no_stroke
end

def draw
  # Do nothing.
end

def draw_it
  background 0
  @creature.render :start, size:  height/5, stop_size: 0.8,
  start_x: width/2, start_y: height/3
end

def mouse_clicked
  draw_it
end
