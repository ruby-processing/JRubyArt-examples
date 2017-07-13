require 'ruby_wordcram'

def settings
  size 600, 350
end

def setup
  sketch_title 'Placing Words'
  background 255
# How should the words be arranged on the screen?
# Each word gets a "target" location. WordCram will
# place it there, and nudge it around until it
# doesn't overlap any other words, or until it
# gives up. High-weighted words are placed first.
#
# Placing words can be a bit tricky. If you try to
# place the words too closely, WordCram will spend
# most of its time trying to place words where
# there's no room. Making the words smaller can help
# there. Also, most placers take the screen width &
# height into account, so those can affect the
# outcome.
  WordCram.new(self)
         .from_text_file(data_path('kari-the-elephant.txt'))
         .draw_all
         # Alternative Placers to try out before draw_all
         #       .with_placer(Placers.center_clump)
         #       .with_placer(Placers.horiz_line)
         #       .with_placer(Placers.horiz_band_anchored_left)
         #       .with_placer(Placers.wave)
         # For this one, try setting the sketch size to 1000x1000.
         #       .with_placer(Placers.swirl)
         #       .sized_by_weight(8, 30)
         #       .with_placer(Placers.upper_left)
         #       .sized_by_weight(10, 40)
end
