require 'skatolo'
# In this simple sketch we attach two buttons to skatolo in the regular way,
# named buttons 'press_me' and 'reset' thanks to some fancy metaprogramming
# we can create methods :press_me and :reset for the buttons
include EventMethod
attr_reader :skatolo, :back_color, :font, :name

def settings
  size(400, 300)
end

def setup
  sketch_title 'Skatolo Text Box'
  create_gui
  skatolo.update # this step is important
  @back_color = color(200, 0, 200)
  text_font(create_font('monospace', 30))
  @name = ''
end

def press_me
  text("Hello #{name}", 10,120)
  @name = ''
end

def draw
  background(back_color)
  @name = input_name_value if name.length.zero?
end

def create_gui
  @skatolo = Skatolo.new(self)
  skatolo.add_button('press_me')
         .set_position(10, 10)
         .set_size(50, 20)
         .set_label('Press Me!')
  @input = skatolo.add_textfield('input_name')
         .set_position(10, 50)
         .set_size(100, 20)
         .set_auto_clear(true)
end
