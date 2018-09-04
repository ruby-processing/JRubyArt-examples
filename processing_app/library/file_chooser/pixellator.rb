load_library :chooser
attr_reader :img, :data, :skip, :poster

###########
# Sophisticated example of file chooser.
###########

KEYS = %w[0 4 5 6 7 8 9)

def settings
  size 500, 500
end

def setup
  sketch_title 'Pixellator'
  color_mode(HSB, 360, 1.0, 1.0)
  resizable
  fill 0, 0, 200
  text('Click Window to Load Image', 10, 100)
  @skip = 5 # controls apparent resolution
  @data = []
  @poster = 0
end

def draw
  image(img, 0, 0) unless img.nil?
  filter(POSTERIZE, poster) unless poster == 0
end

def write_data(name, data)
  df = "  %s [x %d y %d s %0.2f hue %d sat %0.3f brightness 1.0]\n"
  open(data_path('data.cfdg'), 'w') do |pw|
    pw.puts format("shape %s{\n", name)
    data.each do |row|
      pw.puts format(df, *row)
    end
    pw.puts "}\n"
  end
end

def write_start(start, data)
  open(data_path(format('%s.cfdg', start)), 'w') do |pw|
    pw.puts 'CF::Background = [b -1]'
    pw.puts format("startshape %s\n", start)
    pw.puts "shape dot{CIRCLE[]}\n"
    pw.puts "import data.cfdg\n"
  end
  write_data start, data
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

def key_pressed
  case key
  when 'p', 'P'
    export = Thread.new do
      pixellate
    end
    export.join
    puts 'done'
  when 's', 'S'
    save_frame(data_path('original.png'))
  when *KEYS
    @poster = key.to_i
  else
    puts format('key %s was pressed', key)
  end
end

def pixellate
  load_pixels
  shp = 'dot'
  (skip...img.width).step(skip) do |x|
    (skip...img.height).step(skip) do |y|
      pix = pixels[x + y * width]
      sat = saturation(pix)
      hue = hue(pix)
      sz = brightness(pix) * skip
      data << [
        shp, -width / 2 + x, height / 2 - y, sz.round(2), hue, sat
      ] if sz > 0.4
    end
  end
  write_start 'haddock', data
end
