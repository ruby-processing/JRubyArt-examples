#########################
# bar_code.rb (2 of 5)
# demonstrates the vbar
# custom terminal
#########################
require 'cf3'


def setup_the_barcode
  @barcode = ContextFree.define do
    ############ Begin defining custom terminal, a proportional vertical bar
    class << self
      define_method(:vbar) do |some_options|
        options = self.get_shape_values(some_options)
        size = options[:size]
        w = some_options[:w]|| 0.1    # default vbar width is 0.1
        ratio = w * size
        rot = options[:rotation]
        rect_mode(CENTER)
        rotate(rot) if rot
        rect(-0.5 * ratio, -0.4 * size, 0.5 * ratio, 0.6 * size)
        rotate(-rot) if rot
      end
    end
    ########### End definition of custom terminal 'vbar'
    
    shape :strip do
      2.times do
        end_bar x: 0.09
      end
      4.times do
        five x: 0.04
      end
      2.times do
        end_bar x: 0.09
      end
    end
    
    shape :bar, 1 do             # wide
      vbar size: 0.8, w: 0.08, brightness: -1
    end
    
    shape :bar, 1 do             # wide
      vbar size: 0.8, w: 0.06, brightness: -1
    end
    
    shape :bar, 1.6 do             # narrow
      vbar size: 0.8, w: 0.02, brightness: -1
    end
    
    shape :bar, 1.6 do             # narrow
      vbar size: 0.8, w: 0.03, brightness: -1
    end
    
    shape :end_bar, 1.6 do         # narrow extra long
      vbar size: 1, w: 0.03, brightness: -1
    end
    
    shape :five do
      5.times do
        bar x: 0.06
      end
    end
  end
end

def settings
  size 350, 200
end

def setup
  sketch_title 'Bar Code'
  text_font(create_font("Dialog.plain", 24), 24)
  background 255, 255, 0
  draw_text
  setup_the_barcode
  draw_it
end

def draw_it
  @barcode.render :strip, start_x: 0, start_y: height,
               size: height
end

def draw_text
  code = "23467"
  fill 0
  text code, 40, 80
end
