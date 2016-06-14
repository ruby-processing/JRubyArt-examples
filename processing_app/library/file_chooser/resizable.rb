load_library :chooser

attr_reader :img

def settings
  size(400, 200)
end

def setup
  sketch_title 'Image Chooser'
  resizable
  fill 0, 0, 200
  text('Click Window to Load Image', 10, 100)
end

def draw
  image(img, 0, 0) unless img.nil?
end

def file_selected(selection)
  if selection.nil?
    puts 'Nothing Chosen'
  else
    @img = load_image(selection.get_absolute_path)
    surface.set_size(img.width, img.height)
  end
end

def mouse_clicked
  @img = nil
  # java_signature 'void selectInput(String, String)'
  select_input('Select Image File', 'file_selected')
end
