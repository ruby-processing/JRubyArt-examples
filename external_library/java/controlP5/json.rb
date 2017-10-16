load_library :controlP5
include_package 'controlP5'
attr_reader :cp5

def settings
  size(400, 400)
end

def setup
  sketch_title('Test Control')
  @cp5 = ControlP5.new(self)
  cp5.add_slider('s1')
     .set_position(20, 100)
     .set_size(200, 20)
  cp5.add_slider('s2')
     .set_position(20, 130)
     .set_size(200, 20)
     .move_to('extra')
  cp5.load_properties(data_path('default.json'))
end

def draw
  background(20)
end

def key_pressed
  return unless key == 's'
  cp5.save_properties(data_path('default.json'))
  puts cp5.getValue('s1')
end
