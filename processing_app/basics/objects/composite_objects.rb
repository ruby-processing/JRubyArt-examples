load_libraries :eggring

attr_reader :egg_one, :egg_two

def setup
  sketch_title 'Composite Objects'
  @egg_one = EggRing.new(self, width * 0.45, height * 0.5, 0.1, 120)
  @egg_two = EggRing.new(self, width * 0.65, height * 0.8, 0.05, 180)
end

def draw
  background 0
  egg_one.transmit
  egg_two.transmit
end

def settings
  size 640, 360
end
