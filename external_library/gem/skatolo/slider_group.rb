require 'skatolo'
# In this simple sketch we attach three sliders to skatolo in the regular way,
# then group them and attach to an accordion widget, the slider values are sent
# (auto-magically) to the sketch as red_value, green_value and blue_value
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
  %w[red green blue].freeze.each_with_index do |slider, index|
    skatolo.add_slider(slider)
           .set_group(color_group)
           .set_size(100, 15)
           .set_position(0, 10 + 20 * index)
           .set_range(0, 255)
           .set_value(50)
  end
  skatolo.add_accordion('acc')
         .set_position(10, 10)
         .set_size(120, 20)
         .add_item(color_group)
end
