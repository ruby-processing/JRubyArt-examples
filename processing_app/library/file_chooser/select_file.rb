load_library :chooser
###########
# Example Native File Chooser using vanilla processing
# select_input, and file_selected
###########

def setup
  sketch_title 'File Chooser'
  # java_signature 'void selectInput(String, String)'
  select_input('Select a File', 'file_selected')
end

def settings
  size 200, 100
end
  
#  signature 'void file_selected(java.io.File file)'
def file_selected(file)
  puts file.get_absolute_path unless file.nil?
end
