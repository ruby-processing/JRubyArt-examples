require 'toxiclibs'

# Simple recursive branching system inspired by mycelium growth
#
# The vanilla processing sketch was part of the SAC 2013 workshop project
# (c) 2013 Karsten Schmidt
# LGPLv3 licensed
# translated to PiCrate by Martin Prout 2018

load_library :branch

attr_reader :gfx, :root

def setup
  @gfx = Gfx::ToxiclibsSupport.new(self)
  @root = Branch.new(
    self,
    Vec2D.new(0, height / 2),
    Vec2D.new(1, 0),
    10.0
  )
end

def draw
  background(0)
  stroke(255)
  no_fill
  root.run
end

def settings
  full_screen
end
