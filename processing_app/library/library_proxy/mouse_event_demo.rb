load_libraries :library_proxy, :mouse_thing

attr_reader :mouseThing

def settings
  size(800, 600)
end

def setup
  sketch_title 'Mouse Event'
  frameRate(1)
  MouseThing.new(self)
end

def draw
  background(255)
end
