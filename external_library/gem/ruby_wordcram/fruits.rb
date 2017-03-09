# Literate colors from JRubyArt
# uses `web_to_color_array` to create a hash of fruity colors
require 'ruby_wordcram'

PALETTE = %w(#b2c248 #a61733 #f7ca18 #32cd23 #ffc800 #f27935 #ffe5b4 #913d88 #f22613 #ff43a4).freeze
FRUITS = %w(avocado cranberry lemon lime mango orange peach plum pomegranate strawberry).freeze

def settings
  size 800, 500
end

def setup
  sketch_title 'Fruity Colors'
  background(255)
  colors = FRUITS.zip(web_to_color_array(PALETTE)).to_h
  count = 0
  words = FRUITS.map do |fruit|
    word = Word.new(fruit, count)
    count += 1
    word.set_font(create_font(data_path('MINYN___.TTF'), 1))
    word.set_color(colors[fruit])
  end
  @wc = WordCram.new(self)
                .from_words(words.to_java(Word))
                .sized_by_weight(90, 30)
                .draw_all
end
