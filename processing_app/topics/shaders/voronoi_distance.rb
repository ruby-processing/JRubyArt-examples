##
# Voronoi.
#
# GLSL version of the 1k intro Voronoi from the demoscene
# (http://www.pouet.net/prod.php?which=52761)
# Ported from the webGL version available in ShaderToy:
# http://www.iquilezles.org/apps/shadertoy/
# (Look for Voronoi under the Plane Deformations Presets)

attr_reader :voronoi

def setup
  sketch_title 'Voronoi Distance'
  no_stroke
  @voronoi = load_shader(data_path('voronoi_distance.glsl'))
  voronoi.set('resolution', width.to_f, height.to_f)
end

def draw
  voronoi.set('time', millis / 1000)
  shader(voronoi)
  # This kind of effects are entirely implemented in the
  # fragment shader, they only need a quad covering the
  # entire view area so every pixel is pushed through the
  # shader.
  rect(0, 0, width, height)
end

def settings
  size(640, 360, P2D)
end
