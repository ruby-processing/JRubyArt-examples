# city.rb after city.cfdg

require 'cf3'  # NB: requires ruby 1.9 for rand range

def setup_the_city
  @city = ContextFree.define do
    shape :neighborhood do
      split do
        block x: -0.25, y: -0.25
        rewind
        block x: 0.25, y: -0.25
        rewind
        block x: 0.25, y: 0.25
        rewind
        block x: -0.25, y: 0.25
      end
    end

    shape :block do
      buildings size: 0.85
    end

    shape :block, 5 do
      neighborhood size: 0.5, rotation: rand(-PI..PI), hue: rand(2), brightness: rand(0.75..1.75)
    end

    shape :block, 0.1 do
      # Do nothing
    end

    shape :buildings do
      square
    end
  end
end

def settings
  size 600, 600
  smooth
end

def setup
  sketch_title 'City'
  setup_the_city
  @background = color 255, 255, 255
  draw_it
end

def draw
  # Do nothing
end

def draw_it
  background @background
  @city.render :neighborhood,
               start_x: width/2, start_y: height/2,
               size: height/2.5, color: [0.1, 0.1, 0.1]
end

def mouse_clicked
  draw_it
end
