# Many Pages.
#
# Saves a new page into a PDF file each loop through draw().
# Pressing the mouse finishes writing the file and exits the program.
#
load_library :pdf

attr_reader :pdf

def setup
  sketch_title 'Many Pages'
  frame_rate(4)
  @pdf = begin_record(PDF, data_path('Lines.pdf'))
  begin_record(pdf)
end

def draw
  background(255)
  stroke(0, 20)
  stroke_weight(20.0)
  line(mouse_x, 0, width - mouse_y, height)
  pdf.nextPage
end

def mouse_pressed
  end_record
  exit
end

def settings
  size(600, 600)
end
