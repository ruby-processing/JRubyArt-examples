#
# Elevated
# https://www.shadertoy.com/view/MdX3Rr by inigo quilez
# Created by inigo quilez - iq/2013
# License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
# Processing port by Raphaël de Courville.
# 
attr_reader :landscape

TITLE_FORMAT = 'frame: %d - fps %0.2f'.freeze

def setup
  sketch_title 'Landscape'
  no_stroke   
  # The code of this shader shows how to integrate shaders from shadertoy
  # into Processing with minimal changes.
  @landscape = load_shader('landscape.glsl')
  landscape.set('resolution', width.to_f, height.to_f)  
end

def draw  
  landscape.set('time', (millis/1000.0).to_f)
  shader(landscape) 
  rect(0, 0, width, height)
  sketch_title(format(TITLE_FORMAT, frame_count, frame_rate)) if frame_count % 10 == 0   
end


def settings
  size(640, 360, P2D)
end
