
# Animated Mandelbub Using Shadertoy shader created by evilryu
# https://www.shadertoy.com/view/MdXSWn
# License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported
# License. Adapted for JRubyArt by Martin Prout

attr_reader :mandelbub

def setup
  sketch_title 'Mandelbub'
  no_stroke
  @mandelbub = load_shader(data_path('mandelbub.glsl'))
  mandelbub.set('iResolution', width.to_f, height.to_f, 0.0)
end

def draw
  puts frame_rate if (frame_count % 300).zero?
  mandelbub.set('iTime', millis / 1000.0)
  shader(mandelbub)
  rect(0, 0, width, height)
end

def settings
  size(640, 360, P2D)
end
