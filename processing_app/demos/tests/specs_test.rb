include_package 'processing.opengl'

def setup
  sketch_title 'Graphics Spec Test'
  puts(PGraphicsOpenGL.OPENGL_VENDOR)
  puts(PGraphicsOpenGL.OPENGL_RENDERER)
  puts(PGraphicsOpenGL.OPENGL_VERSION)
  puts(PGraphicsOpenGL.GLSL_VERSION)
  puts(PGraphicsOpenGL.OPENGL_EXTENSIONS)
end

def settings
  size(100, 100, P3D)
end
