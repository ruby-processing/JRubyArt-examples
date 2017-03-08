require 'ruby_wordcram'

include Observer # include java interface as a module to enable callbacks

attr_reader :words_drawn, :words_skipped

def settings
  size 1000, 500
end

def setup
  sketch_title 'Call-Backs'
  background 255
  @words_drawn = 0
  @words_skipped = 0
  WordCram.new(self)
          .from_text_file(data_path('kari-the-elephant.txt'))
          .draw_all
end

# keep snake case for java reflection
def wordsCounted(words)
  puts(format('counted %d words!', words.length))
end

# keep snake case for java reflection
def beginDraw
  puts 'drawing the sketch...'
end

# keep snake case for java reflection
def wordDrawn(word)
  @words_drawn += 1
end

# keep snake case for java reflection
def wordSkipped(word)
  @words_skipped += 1
end

# keep snake case for java reflection
def endDraw
  puts 'end draw!'
  puts(format('- skipped: %d', words_skipped))
  puts(format('- drawn:   %d', words_drawn))
end
