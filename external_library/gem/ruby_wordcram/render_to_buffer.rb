# US Constitution text from http://www.usconstitution.net/const.txt
require 'ruby_wordcram'
attr_reader :wc, :buffer, :progress

def settings
  size 640, 480
end

def setup
  sketch_title 'Render To Buffer'
  background(255)
  @buffer = create_graphics(width, height, JAVA2D)
  buffer.begin_draw
  buffer.background(255)
  # red, black, and blue colors
  @wc = WordCram.new(self)
                .from_text_file(data_path('usconst.txt'))
                .to_canvas(buffer)
                .with_colors(color(255, 0, 0), color(0), color(0, 0, 255))
                .sized_by_weight(9, 70)
end

def draw
  background 255
  if wc.has_more
    # draw the progress bar
    @progress = wc.getProgress
    draw_progress_bar(progress)
    draw_progress_text(progress)
    wc.draw_next
  else
    buffer.end_draw
    image(buffer, 0, 0)
    puts 'done'
    no_loop
  end
end

def draw_progress_bar(progress)
  gray = color(progress * 255)
  # Draw the empty box:
  no_fill
  stroke(gray)
  stroke_weight(2)
  rect(100, (height / 2) - 30, (width - 200), 60)
  # Fill in the portion that's done:
  fill(gray)
  rect(100, (height/2)-30, (width-200) * progress, 60)
end

def draw_progress_text(progress)
  text(format('%d%', (progress * 100).round), width / 2, (height / 2) + 50)
end
