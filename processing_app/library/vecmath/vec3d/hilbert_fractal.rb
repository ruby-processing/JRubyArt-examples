########################################################
# A 3D Hilbert fractal implemented using a
# Lindenmayer System in JRubyArt by Martin Prout
# processing-3.0.2+ JRuby-9.0.5.0+
# Demonstrates arcball rotation hold down z, y or z key
# to constrain to that axis of rotation. Otherwise get
# intuitive rotation using mouse drag.
########################################################
load_libraries :hilbert
attr_reader :hilbert

def setup
  sketch_title 'Hilbert Fractal'
  ArcBall.init(self, width / 2.0, height / 2.0)
  @hilbert = Hilbert.new(size: height / 2, gen: 3)
  no_stroke
end

def draw
  background 0
  lights
  define_lights
  ambient(40)
  specular(15)
  hilbert.draw
end

def define_lights
  ambient(20, 20, 20)
  ambient_light(160, 160, 160)
  point_light(30, 30, 30, 0, 0, 0)
  directional_light(40, 40, 50, 1, 0, 0)
  spot_light(30, 30, 30, 0, 40, 200, 0, -0.5, 0.5, PI / 2, 2)
end

def settings
  size 1024, 768, P3D
end
