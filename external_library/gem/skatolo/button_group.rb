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
  sketch_title 'Skatolo Button Group'
  create_gui
  skatolo.update # this step is important
  @back_color = color(200, 0, 200)
end

def draw
  background(back_color)
end

def red_color
  @back_color = color(200, 0, 0)
end

def green_color
  @back_color = color(0, 200, 0)
end

def blue_color
  @back_color = color(0, 0, 200)
end

def create_gui
  @skatolo = Skatolo.new(self)
  color_group = skatolo.add_group('colors')
  skatolo.add_button('red_color')
         .set_group(color_group)
         .set_position(0, 10)
         .set_size(50, 20)
         .set_label('Red')
  skatolo.add_button('green_color')
         .set_group(color_group)
         .set_position(0, 30)
         .set_size(50, 20)
         .set_label('Green')
  skatolo.add_button('blue_color')
         .set_group(color_group)
         .set_position(0, 50)
         .set_size(50, 20)
         .set_label('Blue')
  skatolo.add_accordion('acc')
         .set_position(20, 10)
         .set_size(50, 20)
         .add_item(color_group)
end
