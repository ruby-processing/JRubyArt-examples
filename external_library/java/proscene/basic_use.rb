# Basic Use.
# by Jean Pierre Charalambos.
#
# This example illustrates a direct approach to use proscene by Scene proper
# instantiation.
#
# Press 'h' to display the key shortcuts and mouse bindings in the console.

load_library :proscene
include_package 'remixlab.proscene'
attr_reader :scene

def settings
  size(640, 360, P3D)
end

def setup
  sketch_title 'Basic Use'
  # We instantiate the Scene class
  @scene = Scene.new(self)
  # when damping friction = 0 -> spin
  scene.eye_frame.set_damping(0)
  # puts format('spinning sens: %.3f', scene.eye_frame.spinningSensitivity)
end

def draw
  background(0)
  fill(204, 102, 0, 150)
  scene.draw_torus_solenoid
end

def key_pressed
  damping = scene.eye_frame.damping.zero? ? 0.5 : 0
  scene.eye_frame.set_damping(damping)
  puts format('Camera damping friction now is %.1f', damping)
end
