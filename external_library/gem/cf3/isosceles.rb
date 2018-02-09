require 'cf3'

def setup_the_spiral
  @spiral= ContextFree.define do
    ############ Begin defining custom terminal, an isosceles triangle
    class << self
      define_method(:isosceles) do |some_options| # isosceles triangle
        options = get_shape_values(some_options)
        size = options[:size]
        rot = options[:rotation]
        rotate(rot) if rot
        @app.triangle(-0.5 * size, -0.5 * size, -0.5 * size, 0.5 * size, 0.5 * size, 0.5 * size)
        rotate(-rot) if rot
      end
    end
    ########### End definition of custom terminal 'isosceles'
    shape :spiral do
      isosceles brightness: -1, rotation: 90
      spiral rotation: 135, size: 1 / sqrt(2), x: 1 / sqrt(2)
    end
  end
end

def settings
  size 800, 500
end

def setup
  sketch_title 'Isosceles'
  setup_the_spiral
  draw_it
end

def draw
  # Do nothing.
end

def draw_it
  background 255
  @spiral.render :spiral, size: height, start_x: width / 3, start_y: height / 2
end
