# US Constitution text from http://www.usconstitution.net/const.txt
# Liberation Serif font from RedHat: https://www.redhat.com/promo/fonts/
require 'ruby_wordcram'
load_library :pdf

# After you run this,
# open the sketch's folder.
# See the PDF.
WEB = %w[#000000 #0000dd #ff0000].freeze

def settings
  size(700, 700, PDF, data_path('usconst.pdf'))
end

def setup
  sketch_title 'Render PDF'
  background(255)
  colors = WEB.map{ |web| color(web) } # map color strings to color int
  @wc = WordCram.new(self)
                .from_text_file(data_path('usconst.txt'))
                .with_colors(*colors)
                .with_fonts('LiberationSans')
                .sized_by_weight(4, 140)
                .min_shape_size(1)
                .with_word_padding(1)
                .draw_all
  puts 'Done! Open usconst.pdf to see the results.'
  exit
end
