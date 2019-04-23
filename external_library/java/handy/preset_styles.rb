# Displays 4 sets of sketchy rectangles each with their own preset styles.
# Version 2.0, 4th April, 2016
# Author Jo Wood

load_library :handy
java_import 'org.gicentre.handy.HandyPresets'

attr_reader :h1, :h2, :h3, :h4
FIVE = 5

def settings
  size(1200, 800)
  # size(1200, 800, P2D)
  # size(1200, 800, P3D)
  # size(1200, 800, P2D)
end

def setup
  sketch_title 'Preset Styles Test'
  @h1 = HandyPresets.create_pencil(self)
  @h2 = HandyPresets.create_coloured_pencil(self)
  @h3 = HandyPresets.create_water_and_ink(self)
  @h4 = HandyPresets.create_marker(self)
end

def draw
  background(247, 230, 197)
  fill(0, 255, 0)
  FIVE.times do
    fill(206 + rand(-30..30), 76 + rand(-30..30), 52 + rand(-30..30), 160)
    h1.rect(rand(10..200), rand(10..50), 80, 50)
    h2.rect(rand(310..520), rand(10..50), 80, 50)
    h3.rect(rand(10..200), rand(100..140), 80, 50)
    h4.rect(rand(310..520), rand(100..140), 80, 50)
  end
  no_loop
end
