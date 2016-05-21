##############################
# electrophoresis.rb whatever
# demonstrates the hbar custom
# terminal. Also weighted rules
# by Martin Prout
##############################
require 'cf3'

def setup_the_gel
  @pcr = ContextFree.define do
    ############ Begin defining custom terminal, a proportional horizontal bar
    class << self
      define_method(:hbar) do |some_options|
        options = self.get_shape_values(some_options)
        size = options[:size]
        ht = some_options[:ht] || 0.1   # default hbar width is 0.1
        ratio = ht * size
        rot = options[:rotation]
        rect_mode(CENTER)
        rotate(rot) if rot
        rect(-0.5 * size, -0.5 * ratio, 0.5 * size, 0.5 * ratio)
      end
    end
    ########### End definition of custom terminal 'hbar'

    shape :gel do
      dna brightness: 1.0
    end

    shape :dna do
      split do
        26.times do
          band x: 0.6
          rewind
        end
      end
    end

    shape :band do       # narrow band with 0.66' probability
      hbar size: 0.8, ht: 0.1, brightness: 0.3, alpha: 0.3, hue: 251, saturation: 1.0
      band brightness: 0.5
    end

    shape :band, 0.5 do   # double width band with 0.33' probability
      hbar size: 0.8, ht: 0.15, brightness: 0.8, alpha: 0.6, hue: -36, saturation: 1.0
      band brightness: 0.5
    end

    shape :band, 0.08 do  # a low probability empty rule used to end recursion
    end

    shape :band do
      band y: -0.23
    end

    shape :band do
      band y: 0.17
    end

    shape :band do
       band y: 0.29
    end

    shape :band do
      band y: -0.33
    end

  end
end

def settings
  size 500, 300
end

def setup
  sketch_title 'PCR gel'
  background 0, 0, 180
  setup_the_gel
  draw_it
end

def draw
  # needed to have a draw loop so we can re-run on mouse click
end

def draw_it
  @pcr.render :gel, start_x: -50, start_y: height/2,
               size: height/5, color: [252, 0.8, 0.8, 1.0]
end

def mouse_clicked
  draw_it
end
