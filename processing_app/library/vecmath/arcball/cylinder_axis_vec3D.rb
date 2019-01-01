# frozen_string_literal: true

INSTRUCTIONS = <<~TEXT
  #######################################################
  1. Mouse Drag to rotate axes
  2. Hold down x, y or z key to clamp rotation in one axis
  3. Mouse wheel to zoom
  Red   = xaxis
  Green = yaxis
  Blue  = zaxis
  #######################################################
TEXT

load_library :axes

attr_reader :axes

def setup
  sketch_title 'Rotate Axes'
  ArcBall.init self
  @axes = Axes.new self
  puts INSTRUCTIONS
end

def draw
  background(128, 128, 128)
  lights
  no_stroke
  axes.draw
end

def settings
  size(500, 500, P3D)
end
