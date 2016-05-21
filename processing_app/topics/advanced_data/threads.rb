
#
# Thread function example
# by Martin Prout (after a Dan Schiffman vanilla processing version).
#
# This example demonstrates how to use Thread.new to spawn
# a process that happens outside of the main animation thread.
#
# When Thread.new is called, the draw loop will continue while
# the code inside the block passed to the thread will operate
# in the background.
#
# For more about threads, see: http://wiki.processing.org/w/Threading
#

# This sketch will load data from all of these URLs in a separate thread

URLS = [
  'https://processing.org',
  'https://www.processing.org/exhibition/',
  'https://www.processing.org/reference/',
  'https://www.processing.org/reference/libraries',
  'https://www.processing.org/reference/tools',
  'https://www.processing.org/reference/environment',
  'https://www.processing.org/learning/',
  'https://www.processing.org/learning/basics/',
  'https://www.processing.org/learning/topics/',
  'https://www.processing.org/learning/gettingstarted/',
  'https://www.processing.org/download/',
  'https://www.processing.org/shop/',
  'https://www.processing.org/about/'
]

attr_reader :finished, :percent

def setup
  sketch_title 'Threads'
  # Spawn the thread!
  # This will keep track of whether the thread is finished
  load_data
end

def draw
  background(0)
  # If we're not finished draw a 'loading bar', so that we can see the progress
  # of the thread. This would not be necessary in a sketch where you wanted to
  # load data in the background and hide this from the user.
  if !finished
    stroke(255)
    no_fill
    rect(width / 2 - 150, height / 2, 300, 10)
    fill(255)
    # The size of the rectangle is mapped to the percentage completed
    w = map1d(percent, (0..1.0), (0..300))
    rect(width / 2 - 150, height / 2, w, 10)
    text_size(16)
    text_align(CENTER)
    fill(255)
    text('Loading', width / 2, height / 2 + 30)
  else
    # The thread is complete!
    text_align(CENTER)
    text_size(24)
    fill(255)
    message = 'Finished loading. Click the mouse to load again.'
    text(message, width / 2, height / 2)
  end
end

def load_data
  Thread.new do
    # The thread is not completed
    @finished = false
    @percent = 0
    # Reset the data to empty
    @all_data = ''
    URLS.each_with_index do |url, i|
      lines = load_strings(url)
      all_txt = lines.join(' ')
      words = all_txt.scan(/\w+/)
      words.each do |word|
        word.strip!
        word.downcase!
      end
      words.sort!
      @all_data << words.join(' ')
      @percent = i.to_f / URLS.length
    end
    @finished = true
  end
end

def mouse_pressed   # guard against calling load_data when running
  load_data if finished
end

def settings
  size 640, 360
end
