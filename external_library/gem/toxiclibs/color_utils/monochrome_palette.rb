require 'toxiclibs'
include_package 'toxi.color'
include_package 'toxi.color.theory'

attr_reader :list

def settings
  size 500, 100
end

def setup
  sketch_title 'blues'
  @list = MonochromeTheoryStrategy.new.create_list_from_color(TColor::BLUE)
  x = 0
  list.each do |col|
    fill col.toARGB
    rect x, 0, x + 100, 100
    x += 100
  end
end

def draw
end

def key_pressed
  File.open(data_path('color.rb'), 'w') do |file|
    file.write("# Monochrome Blue\n")
    file.write(list.to_ruby_string)
  end
end
