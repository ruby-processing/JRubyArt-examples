require 'skatolo'
# In this simple sketch we attach a slider to skatolo in the regular way, with
# a named slider 'background_color' and thanks to some fancy metaprogramming
# we can read the result from background_color_value
include EventMethod
attr_reader :skatolo

def settings
  size(400, 300)
end

def setup
  sketch_title 'Skatolo Slider'
  create_gui
  skatolo.update # this step is important
end

def draw
  background(background_color_value)
end

def create_gui
  @skatolo = Skatolo.new(self)
  skatolo.add_slider('background_color')
         .set_position(10, 10)
         .set_size(150, 20)
         .set_range(80, 255)
         .set_value(180)
         .set_label('Background color')
 end
