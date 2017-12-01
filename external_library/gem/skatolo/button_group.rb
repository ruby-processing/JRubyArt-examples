require 'skatolo'
# In this simple sketch we attach three buttons to skatolo in the regular way,
# and group them, then add the group to the accordion widget
# named buttons 'red_color' ... thanks to some fancy metaprogramming
# we can create methods :red_color, :green_color and :blue_color buttons
COLOR = %w[Red Green Blue].freeze

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
  %w[red_color green_color blue_color].freeze.each_with_index do |col, index|
    skatolo.add_button(col)
           .set_group(color_group)
           .set_position(0, 10 + index * 20)
           .set_size(50, 20)
           .set_label(COLOR[index])
  end
  skatolo.add_accordion('acc')
         .set_position(20, 10)
         .set_size(50, 20)
         .add_item(color_group)
end
