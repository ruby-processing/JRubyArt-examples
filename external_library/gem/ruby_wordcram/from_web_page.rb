
# This sketch shows how to make a WordCram from any webpage.
# It uses my blog
# Minya Nouvelle font available at http://www.1001fonts.com/font_details.html?font_id=59
require 'ruby_wordcram'

def settings
  size 800, 400
end

def setup
  sketch_title 'WordCram from Web Page'
  color_mode(HSB)
  background(255)
  WordCram.new(self)
          .from_web_page('https://ruby-processing.github.io/about/')
          .with_font(create_font(data_path('MINYN___.TTF'), 1))
          .with_colorer(Colorers.two_hues_random_sats_on_white(self))
          .sized_by_weight(7, 100)
          .draw_all
end
