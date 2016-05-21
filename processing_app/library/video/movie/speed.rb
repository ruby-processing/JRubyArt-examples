# Speed.
# drag mouse down screen to increase speed
# drag mouse ip screen to decrease speed
# Uses the Movie.speed method to change
# the playback speed.

load_libraries :video, :video_event
include_package 'processing.video'

attr_reader :mov

def setup
  sketch_title 'Speed'
  background(0)
  @mov = Movie.new(self, 'transit.mov')
  mov.loop
end

def draw
  image(mov, 0, 0)
  new_speed = map1d(mouse_y, (0..height), (0.1..2))
  mov.speed(new_speed)
  fill(255)
  text(format('%.2fX', new_speed), 10, 30)
end

# use camel case to match java reflect method
java_signature 'movieEvent(processing.event.Event m)'
def movieEvent(m)
  m.read
end

def settings
  size 640, 360, FX2D
end
