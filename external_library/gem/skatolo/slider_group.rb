require 'skatolo'
# In this simple sketch we attach two buttons to skatolo in the regular way,
# named buttons 'press_me' and 'reset' thanks to some fancy metaprogramming
# we can create methods :press_me and :reset for the buttons

include EventMethod
attr_reader :skatolo, :back_color

def settings
  size(400, 300)
end

def setup
  sketch_title 'Skatolo Slider Group'
  create_gui
  skatolo.update # this step is important
  @back_color = color(200, 0, 200)
end

def draw
  background(red_value, green_value, blue_value)
end

def create_gui
  @skatolo = Skatolo.new(self)
  color_group = skatolo.add_group('colors')
  skatolo.add_slider('red')
         .set_group(color_group)
         .set_size(100, 15)
         .set_position(0, 10)
         .set_range(0, 255)
         .set_value(50)
  skatolo.add_slider('green')
         .set_group(color_group)
         .set_size(100, 15)
         .set_position(0, 30)
         .set_range(0, 255)
         .set_value(50)
  skatolo.add_slider('blue')
         .set_group(color_group)
         .set_size(100, 15)
         .set_position(0, 50)
         .set_range(0, 255)
         .set_value(50)
  skatolo.add_accordion('acc')
         .set_position(10, 10)
         .set_size(120, 20)
         .add_item(color_group)
end
