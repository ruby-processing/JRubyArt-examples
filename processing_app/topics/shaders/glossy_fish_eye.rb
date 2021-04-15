# Glossy Fish Eye
#
# A fish-eye shader is used on the main surface and
# a glossy specular reflection shader is used on the
# offscreen canvas.

attr_reader :ball, :canvas, :glossy, :fisheye, :img, :use_fish_eye
SHADERS = %w[FishEye.glsl GlossyFrag.glsl GlossyVert.glsl].freeze

def setup
  sketch_title 'Glossy fish eye'
  @canvas = create_graphics(width, height, P3D)
  @use_fish_eye = true
  shaders = SHADERS.map { |shader| data_path(shader) }
  @fisheye = load_shader(shaders[0])
  fisheye.set('aperture', 180.0)
  @glossy = load_shader(shaders[1], shaders[2])
  glossy.set('AmbientColour', 0.0, 0.0, 0.0)
  glossy.set('DiffuseColour', 0.9, 0.2, 0.2)
  glossy.set('SpecularColour', 1.0, 1.0, 1.0)
  glossy.set('AmbientIntensity', 1.0)
  glossy.set('DiffuseIntensity', 1.0)
  glossy.set('SpecularIntensity', 0.7)
  glossy.set('Roughness', 0.7)
  glossy.set('Sharpness', 0.0)
  @ball = create_shape(SPHERE, 50)
  ball.set_stroke(false)
end

def draw
  canvas.begin_draw
  canvas.shader(glossy)
  canvas.no_stroke
  canvas.background(0)
  canvas.push_matrix
  canvas.rotate_y(frame_count * 0.01)
  canvas.point_light(204, 204, 204, 1_000, 1_000, 1_000)
  canvas.pop_matrix
  grid(width, width, width, 100, 100, 100) do |x, y, z|
        canvas.push_matrix
        canvas.translate(x, y, -z)
        canvas.shape(ball)
        canvas.pop_matrix
  end
  canvas.end_draw
  shader(fisheye) if use_fish_eye
  image(canvas, 0, 0, width, height)
end

def mouse_pressed
  @use_fish_eye = !use_fish_eye
  reset_shader
end

def settings
  size(640, 640, P3D)
end
