# raining after Rain1 by Thomas R. 'TomK32' Koll
#
# draws raindrops as bezier shapes and moves them downwards
#
# available key commands:
#  + make raindrops heavier/bigger
#  - make raindrops smaller
#  a more raindrops
#  s less raindrops
#  <SPACE>
#
# License: Same as processing
#
load_library :rain_drops

attr_reader :drops, :weight, :drops_size, :paused

def settings
  size 640, 480
end

def setup
  sketch_title "It's Raining"
  frame_rate 30
  @drops_size = 20
  @weight = 20
  @drops = RainDrops.new width, height
  @paused = false
  font = create_font('Georgia', 15)
  text_font(font)
end

def draw
  return if paused
  # we fill up with new drops randomly
  drops.fill_up(weight) while rand(drops_size / 3) < (drops_size - drops.size)
  # the less drops the darker it is
  background 127 + 127 * (drops.size / drops_size.to_f)
  drops.run
  form = '%d of %d drops with a size of %d'
  text(format(form, drops.size, drops_size, weight), 10, 20)
end

def key_pressed
  case key
  when '+'
    @weight += 5
  when '-'
    @weight -= 5 if weight > 10
  when 'a'
    @drops_size += 5
  when 's'
    @drops_size -= 5 if drops_size > 5
  when ' '
    @paused = !paused
  end
end
