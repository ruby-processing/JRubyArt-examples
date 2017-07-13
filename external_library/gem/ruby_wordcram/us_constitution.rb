# US Constitution text from http://www.usconstitution.net/const.txt
# Liberation Serif font from RedHat: https://www.redhat.com/promo/fonts/
require 'ruby_wordcram'

attr_reader :wc, :reset

def settings
  size 800, 600
end

def setup
  sketch_title 'US Constitution'
  color_mode HSB
  init_wordcram
  @reset = true
end

def init_wordcram
  @wc = WordCram.new(self)
            .from_text_file(data_path('usconst.txt'))
            .with_font(create_font(data_path('LiberationSerif-Regular.ttf'), 1))
            .with_colors(color(0, 250, 200), color(30), color(170, 230, 200))
            .sized_by_weight(10, 90)
end

def draw
  background 255 if reset
  @reset = false
  if wc.has_more
    wc.draw_next
  else
    puts 'done'
    no_loop
  end
end

def mouse_clicked
  init_wordcram
  @reset = true
  loop
end
