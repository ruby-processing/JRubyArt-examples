load_library :chooser

attr_reader :img

def settings
  size(440, 223)
end

def setup
  sketch_title 'Image Chooser'
  resizable
  @img = load_image(data_path('Message.png'))
end

def draw
  image(img, 0, 0)
end

def file_selected(selection)
  return puts 'Nothing Chosen' if selection.nil?
  @img = load_image(selection.get_absolute_path)
  surface.set_size(img.width, img.height)
end

def mouse_clicked
  # java_signature 'void selectInput(String, String)'
  select_input('Select Image File', 'file_selected')
end
