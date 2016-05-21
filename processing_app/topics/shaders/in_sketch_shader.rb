# encoding: utf-8
# After an articles on processing forum by user Poersch
# https://forum.processing.org/two/profile/7061/Poersch

VERT_SRC = [
  "uniform mat4 transform;",
  "attribute vec4 vertex;",
  "attribute vec2 texCoord;",
  "varying vec2 vertTexCoord;",
  "void main() {",
      "vertTexCoord = texCoord;",
      "gl_Position = transform * vertex;",
  "}"
].freeze

FRAG_SRC = [
 "uniform vec4 colorA;",
 "uniform vec4 colorB;",
 "varying vec2 vertTexCoord;",
 "void main() {",
      "float dist = distance(vertTexCoord, vec2(0.5, 0.5));",
      "if(dist > 0.2 && dist < 0.5)",
          "gl_FragColor = mix(colorA, colorB, (dist - 0.2) * 3.33);",
 "}"
].freeze

def settings
  size(600, 600, P3D)
  smooth
end

def setup
  sketch_title 'In Sketch Shader'
  ArcBall.init(self) # drag mouse to rotate, use wheel to zoom
  texture_mode(NORMAL)
  no_stroke
  gradient_fill = PShader.new(self, VERT_SRC.to_java(:string), FRAG_SRC.to_java(:string))
  shader(gradient_fill)
  gradient_fill.set('colorA', 0.0, 0.0, 0.392, 1.0) # red, green, blue, alpha
  gradient_fill.set('colorB', 1.0, 0.0, 0.392, 1.0) # normalized in shader world
end

def draw
  background(255)
  texture_rect
end

def texture_rect
  begin_shape(QUADS)
  vertex(-250, -250, 0.0, 0.0)
  vertex(+250, -250, 1.0, 0.0)
  vertex(+250, +250, 1.0, 1.0)
  vertex(-250, +250, 0.0, 1.0)
  end_shape
end
