load_library :controlP5
include_package 'controlP5'

attr_reader :r1, :back_color

def settings
  size(400,400)
end

def setup
  sketch_title 'Button Group'
  @back_color = color(0, 0, 0)
  cp5 = ControlP5.new(self)
  group_fluid = cp5.addGroup('groceries')
                   .setPosition(20, 20)
                   .setBackgroundHeight(100)
                   .setBackgroundColor(color(255, 50))
  cp5.addButton('fish')
     .setPosition(10, 20)
     .setSize(80, 20)
     .setGroup('groceries')
     .activateBy(ControlP5::RELEASE)
     .setValue(9)
     .addListener { |event| puts event.getValue }
  cp5.addButton('fruit')
     .setPosition(10, 60)
     .setSize(80, 20)
     .setGroup('groceries')
     .addListener { |event| puts event }
end


def draw
  background(back_color)
end
