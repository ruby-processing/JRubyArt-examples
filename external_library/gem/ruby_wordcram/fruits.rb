# Literate colors from JRubyArt
# uses `web_to_color_array` to create a hash of fruity colors
# to join two words as `cherry\ red` use back slash
require 'ruby_wordcram'

# Other suggested sources for usable palette are http://colorbrewer2.org/

PALETTE = %w(#b2c248 #c40000 #a61733 #f7ca18 #32cd23 #ffc800 #f27935 #ffe5b4 #913d88 #f22613 #c72c48 #ff43a4).freeze
FRUITS = %w(avocado cherry\ red cranberry lemon lime mango orange peach plum pomegranate raspberry strawberry).freeze

def settings
  size 600, 480
end

def setup
  sketch_title 'Fruity Colors'
  background(255)
  colors = FRUITS.zip(web_to_color_array(PALETTE)).to_h
  longest = FRUITS.max { |a, b| a.length <=> b.length }
  shortest = FRUITS.min { |a, b| a.length <=> b.length }
  words = FRUITS.map do |fruit|
    weight = norm_strict(fruit.length, longest.length, shortest.length)
    word = Word.new(fruit, weight)
    word.set_font(create_font(data_path('MINYN___.TTF'), 1))
    word.set_color(colors[fruit])
  end
  WordCram.new(self)
          .from_words(words.to_java(Word))
          .sized_by_weight(20, 80)
          .draw_all
end
