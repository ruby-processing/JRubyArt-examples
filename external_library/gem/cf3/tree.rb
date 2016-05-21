# tree.rb by jashkenas
# This sketch demonstrates a lil' Ruby DSL for defining
# context-free drawings. Each shape rule calls itself by chance.

require  'cf3'
load_library :control_panel

attr_reader :panel, :hide

def setup_the_trees
  control_panel do |panel|
    panel.look_feel "Metal"
    panel.slider :srand, (0..100), 50
    @panel = panel
  end

  @tree = ContextFree.define do

    shape :seed do
      square
      leaf y: 0 if size < 4.5 && rand < 0.018
      flower y: 0 if size < 2.0 && rand < 0.02
      seed y: -1, size: 0.986, rotation: 3, brightness: 0.989
    end

    shape :seed, 0.1 do
      square
      seed flip: true
    end

    shape :seed, 0.04 do
      square
      split do
        seed flip: true
        rewind
        seed size: 0.8, rotation: rand(50), flip: true
        rewind
        seed size: 0.8, rotation: rand(50)
      end
    end

    shape :leaf do
      the_size = rand(25)
      the_x = [1, 0, 0, 0][rand(4)]
      circle size: the_size, hue: 54, saturation: 1.25, brightness: 0.9, x: the_x
    end

    shape :flower do
      split saturation: 0, brightness: rand(1.3)+4.7, w: rand(15)+10, h: rand(2)+2 do
        (0..135).step(45) do |rot|
          oval rotation: rot
        end
      end
    end
  end
end

def settings
  size 800, 800
end

def setup
  sketch_title 'Tree'
  @hide = false
  setup_the_trees
  no_stroke
  frame_rate 5
  draw_it
end

def draw
  panel.set_visible(true) unless hide
end

def draw_it
  Kernel::srand(@srand) if @srand
  background(color(rand(0..255), rand(0..255), rand(0..255), 255))
  @tree.render :seed, start_x: width/2, start_y: height+20,
                      size: height/60, color: [252, 0.15, 0.8, 1]
end

def mouse_clicked
  @hide = false
  panel.set_visible(true)
  draw_it
  @hide = true
end
