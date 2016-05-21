##################
# From an original sketch on openprocessing by Chinchbug
# http://www.openprocessing.org/sketch/29577
#
# Note: ruby syntax 'rjust' for padding a number string
##################
FRAMES = 116
IMG_F = 'a%s copy.jpg'
MESS_F = 'loading frames (%s of 115)'

attr_reader :ang, :curr, :frames

def setup
  sketch_title 'Threads Two'
  background(0)
  no_stroke
  text_align(CENTER, CENTER)
  @frames = []
  @done_loading = false
  @curr = 0
  load_image_thread
  @ang = 0.0
end

def load_image_thread
  thread do     # supply a block in JRubyArt rather than use reflection
    FRAMES.times do |i|
      frames << load_image(format(IMG_F, i.to_s.rjust(3, '0')))
      @curr = i
      delay(75) # slows down this thread, the main draw cycle is unaffected
    end
    @curr = 0
    frame_rate(30)
  end
end

def draw
  if frames.length < FRAMES
    display_loading ang
    @ang += 0.1
  else
    display_animation
  end
end

def display_animation
  background(0)
  image(frames[curr], 0, 0)
  @curr += 1
  @curr = 0 if curr >= FRAMES
end

def display_loading(ang)
  x = cos(ang) * 8
  y = sin(ang) * 8
  fill(0, 8)
  rect(50, 150, 100, 100)
  fill(32, 32, 255)
  ellipse(x + 100, y + 200, 8, 8)
  fill(0)
  rect(120, 150, 170, 100)
  fill(128)
  text(format(MESS_F, curr), 200, 200)
end

def settings
  size(305, 395)
end

