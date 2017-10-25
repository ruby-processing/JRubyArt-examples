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
  sketch_title 'Skatolo Buttons'
  create_gui
  skatolo.update # this step is important
  @back_color = color(200, 0, 200)
end

def draw
  background(back_color)
end

def reset
  @back_color = color(200, 0, 200)
end

def press_me
  @back_color = color(200, 0, 0)
end

def create_gui
  @skatolo = Skatolo.new(self)
  skatolo.add_button('press_me')
         .set_position(10, 10)
         .set_size(50, 20)
         .set_label('Press Me!')
  skatolo.add_button('reset')
         .set_position(10, 40)
         .set_size(50, 20)
         .set_label('Reset!')
end
