require 'ruby_wordcram'

attr_reader :wc

def settings
  size 600, 400
end

def setup
  sketch_title 'Get Words While Running'
  background(20, 20, 30)
  @wc = WordCram.new(self)
                     .from_text_file(data_path('usconst.txt'))
                     .with_color(color('#ededed'))
                     .sized_by_weight(8, 70)
end

def draw
  return no_loop unless wc.has_more
  wc.draw_next
  report
end

def report
  words = wc.get_words
  too_many = 0
  too_small = 0
  could_not_place = 0
  placed = 0
  left = 0
  words.each do |word|
    if word.was_skipped
      case(word.was_skipped_because)
      when WordSkipReason::WAS_OVER_MAX_NUMBER_OF_WORDS
        too_many += 1
      when WordSkipReason::SHAPE_WAS_TOO_SMALL
        too_small += 1
      when WordSkipReason::NO_SPACE
        could_not_place += 1
      end
    elsif word.was_placed
      placed += 1
    else
      left += 1
    end
  end
  puts "TooMany #{too_many}"
  puts "TooSmall #{too_small}"
  puts "CouldNotPlace #{could_not_place}"
  puts "Placed #{placed}"
  puts "Left #{left}"
end
