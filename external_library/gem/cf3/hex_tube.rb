#########################
# hextube.rb by Martin Prout
#########################
require 'cf3'

def setup_the_hextube
  @hexa = ContextFree.define do
    ############ Begin defining custom terminal, as a hexagon (path C++ cfdg)
    class << self
      define_method(:hexagon) do |some_options|
        options = self.get_shape_values(some_options)
        size = options[:size]
        rot = (options[:rotation])? options[:rotation]: 0
        no_fill
        stroke(*options[:color])
        stroke_weight(size/30)
        begin_shape
        6.times do |i|
          vertex(size * Math.cos(Math::PI * i/3 + rot), size * Math.sin(Math::PI * i/3 + rot))
        end
        end_shape(CLOSE)
      end
    end
    ########### End definition of custom terminal 'hexagon'
    shape :hextube do
      hexa brightness: 1.0
    end

    shape :hexa do |i = nil, j = 0.5|
      hexagon size: 1, brightness: 1.0
      hexa size: 0.9, rotation: 5 *j
    end
  end
end

def settings
  size 800, 800
end

def setup
  sketch_title 'Hex-Tube'
  background 0
  setup_the_hextube
  draw_it
end

def draw_it
  @hexa.render :hextube, start_x: width/2, start_y: height/2,
               size: height/2.1, color: [60, 1, 1, 0.5]
end
