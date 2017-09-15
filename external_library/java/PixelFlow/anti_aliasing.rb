load_library :PixelFlow, :peasycam

module AA
  java_import 'com.thomasdiewald.pixelflow.java.DwPixelFlow'
  java_import 'com.thomasdiewald.pixelflow.java.antialiasing.FXAA.FXAA'
  java_import 'com.thomasdiewald.pixelflow.java.antialiasing.GBAA.GBAA'
  java_import 'com.thomasdiewald.pixelflow.java.antialiasing.SMAA.SMAA'
  java_import 'com.thomasdiewald.pixelflow.java.dwgl.DwGLTextureUtils'
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwCube'
  java_import 'com.thomasdiewald.pixelflow.java.geometry.DwMeshUtils'
  java_import 'com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter'
  java_import 'com.thomasdiewald.pixelflow.java.render.skylight.DwSceneDisplay'
  java_import 'com.thomasdiewald.pixelflow.java.utils.DwMagnifier'
  java_import 'peasy.PeasyCam'
  java_import 'processing.core.PShape'
end

include AA

VIEWPORT_W = 1280
VIEWPORT_H = 720
VIEWPORT_X = 230
VIEWPORT_Y = 0
GAMMA = 2.2
BACKGROUND_COLOR = 32.0
attr_reader :peasycam, :context, :fxaa, :smaa, :gbaa, :pg_render_noaa, :magnifier
attr_reader :pg_render_smaa, :pg_render_fxaa, :pg_render_msaa, :pg_render_gbaa
attr_reader :aamode, :smaamode, :font12, :font48, :display, :shp_scene

SMAA_MODE = { 'q' => :EDGES, 'w' => :BLEND, 'e' => :FINAL }
AA_MODE =  { '1' => :NoAA, '2' => :MSAA, '3' => :SMAA, '4' => :FXAA, '5' => :GBAA }
def settings
  size(VIEWPORT_W, VIEWPORT_H, P3D)
  smooth(0)
end

def setup
  surface.set_location(VIEWPORT_X, VIEWPORT_Y)
  @aamode = :NoAA
  @smaamode = :FINAL
  # camera
  @peasycam = PeasyCam.new(self, -4.083, -6.096, 7.000, 2_000)
  peasycam.set_rotations(1.085, -0.477, 2.910)
  # projection
  perspective(60.radians, width / height.to_f, 2, 6_000)
  # processing font
  @font48 = create_font('SourceCodePro-Regular', 48)
  @font12 = create_font('SourceCodePro-Regular', 12)
  @context = DwPixelFlow.new(self)
  context.print
  context.printGL
  # MSAA - main render-target for MSAA
  @pg_render_msaa = create_graphics(width, height, P3D)
  pg_render_msaa.smooth(8)
  pg_render_msaa.textureSampling(5)
  # NOAA - main render-target for FXAA and MSAA
  @pg_render_noaa = create_graphics(width, height, P3D)
  pg_render_noaa.smooth(0)
  pg_render_noaa.textureSampling(5)
  # FXAA
  @pg_render_fxaa = create_graphics(width, height, P3D)
  pg_render_fxaa.smooth(0)
  pg_render_fxaa.textureSampling(5)
  # FXAA
  @pg_render_smaa = create_graphics(width, height, P3D)
  pg_render_smaa.smooth(0)
  pg_render_smaa.textureSampling(5)
  # GBAA
  @pg_render_gbaa = create_graphics(width, height, P3D)
  pg_render_gbaa.smooth(0)
  pg_render_gbaa.textureSampling(5)
  scene_display = lambda do |canvas|
    # lights
    canvas.directionalLight(255, 255, 255, 200,600,400)
    canvas.directionalLight(255, 255, 255, -200,-600,-400)
    canvas.ambientLight(64, 64, 64)
    # canvas.shape(shape)
    sceneShape(canvas)
  end
  # AA post-processing modes
  @fxaa = FXAA.new(context)
  @smaa = SMAA.new(context)
  @gbaa = GBAA.new(context, scene_display)
  mag_h = (height / 2.5).to_i
  @magnifier = DwMagnifier.new(self, 4, 0, height - mag_h, mag_h, mag_h)
  frame_rate(1_000)
end

def draw
  case aamode
  when :MSAA
    displaySceneWrap(pg_render_msaa)
    # RGB gamma correction
    DwFilter.get(context).gamma.apply(pg_render_msaa, pg_render_msaa, GAMMA)
  when :NoAA, :SMAA, :FXAA
    displaySceneWrap(pg_render_noaa)
    # RGB gamma correction
    DwFilter.get(context).gamma.apply(pg_render_noaa, pg_render_noaa, GAMMA)
    smaa.apply(pg_render_noaa, pg_render_smaa) if aamode == :SMAA
    fxaa.apply(pg_render_noaa, pg_render_fxaa) if aamode == :FXAA
  when :GBAA
    displaySceneWrap(pg_render_noaa)
    # RGB gamma correction
    DwFilter.get(context).gamma.apply(pg_render_noaa, pg_render_noaa, GAMMA)
    gbaa.apply(pg_render_noaa, pg_render_gbaa)
  end
  case aamode
  when :MSAA
    @display = pg_render_msaa
  when :SMAA
    @display = pg_render_smaa
  when :FXAA
    @display = pg_render_fxaa
  when :GBAA
    @display = pg_render_gbaa
  else
    @display = pg_render_noaa
  end
  magnifier.apply(display, mouse_x, mouse_y)
  magnifier.display_tool
  peasycam.beginHUD
  # display Anti Aliased result
  blend_mode(REPLACE)
  clear
  image(display, 0, 0)
  blend_mode(BLEND)
  # display magnifer
  magnifier.display(g)
  # display AA name
  mode = aamode.to_s
  buffer = ''
  if aamode == :SMAA
    buffer = " [#{smaamode}]" if smaamode == :EGDES
    buffer = " [#{smaamode}]" if smaamode == :BLEND
  end
  noStroke
  fill(0,150)
  rect(0, height-65, magnifier.w, 65)
  tx = 10
  ty = 20
  textFont(font12)
  fill(200)
  text('[1] NoAA', tx, ty)
  text('[2] MSAA - MultiSample AA', tx, ty+=20)
  text('[3] SMAA - SubPixel Morphological AA', tx, ty+=20)
  text('[4] FXAA - Fast Approximate AA', tx, ty+=20)
  text('[5] GBAA - GeometryBuffer AA', tx, ty+=20)

  textFont(font48)
  tx = 20
  ty = height-20
  fill(0)
  text(mode + buffer, tx+2, ty+2)

  fill(255,200,0)
  text(mode + buffer, tx, ty)


  peasycam.endHUD

  # some info, window title
  format_string = 'Anti Aliasing | fps: (%6.2f)'
  surface.setTitle(format(format_string, frame_rate))
end

def displaySceneWrap(canvas)
  canvas.beginDraw
  DwGLTextureUtils.copyMatrices(g, canvas)
  background_color_gamma = (BACKGROUND_COLOR / 255.0)**GAMMA * 255.0
  # background
  canvas.blendMode(BLEND)
  canvas.background(background_color_gamma)
  displayScene(canvas)
  canvas.endDraw
end

# render something
def displayScene(canvas)
  # lights
  canvas.directionalLight(255, 255, 255, 200,600,400)
  canvas.directionalLight(255, 255, 255, -200,-600,-400)
  canvas.ambientLight(64, 64, 64)
  # canvas.shape(shape)
  sceneShape(canvas)
end

@shp_scene ||= nil

def sceneShape(canvas)
  return canvas.shape(shp_scene) unless shp_scene.nil?
  @shp_scene = createShape(GROUP)
  num_boxes = 50
  num_spheres = 50
  bb_size = 800
  xmin = -bb_size
  xmax = +bb_size
  ymin = -bb_size
  ymax = +bb_size
  zmin = 0
  zmax = +bb_size
  color_mode(HSB, 360.0, 1.0, 1.0)
  srand(0)
  (0..num_boxes).each do
    px = rand(xmin..xmax)
    py = rand(ymin..ymax)
    sx = rand(10..210)
    sy = rand(10..210)
    sz = rand(zmin..zmax)
    off = 45
    base = 0
    hsb_h = base + rand(-off..off)
    hsb_s = 1
    hsb_b = rand(0.1..1.0)
    shading = color(hsb_h, hsb_s, hsb_b)
    shp_box = createShape(BOX, sx, sy, sz)
    shp_box.setFill(true)
    shp_box.setStroke(false)
    shp_box.setFill(shading)
    shp_box.translate(px, py, sz / 2)
    shp_scene.addChild(shp_box)
  end
  cube_smooth = DwCube.new(4)
  cube_facets = DwCube.new(2)
  (0..num_spheres).each do
    px = rand(xmin..xmax)
    py = rand(ymin..ymax)
    pz = rand(zmin..zmax)
    rr = rand(50..100)
    facets = true # (i%2 == 0)
    off = 20
    base = 225
    hsb_h = base + rand(-off..off)
    hsb_s = rand(0.1..1.0)
    hsb_b = 1
    shading = color(hsb_h, hsb_s, hsb_b)
    shp_sphere = createShape(PShape::GEOMETRY)
    if facets
      DwMeshUtils.createPolyhedronShape(shp_sphere, cube_facets, 1, 4, false)
    else
      DwMeshUtils.createPolyhedronShape(shp_sphere, cube_smooth, 1, 4, true)
    end
    shp_sphere.setStroke(false)
    shp_sphere.setStroke(color(0))
    shp_sphere.setStrokeWeight(0.01 / rr)
    shp_sphere.setFill(true)
    shp_sphere.setFill(shading)
    shp_sphere.resetMatrix
    shp_sphere.scale(rr)
    shp_sphere.translate(px, py, pz)
    shp_scene.addChild(shp_sphere)
  end
  colorMode(RGB, 255, 255, 255)
  shp_rect = createShape(RECT, -1000, -1000, 2000, 2000)
  shp_rect.setStroke(false)
  shp_rect.setFill(true)
  shp_rect.setFill(color(255))
  shp_scene.addChild(shp_rect)
end

# def create_grid_xy(lines, s)
#   shp_gridxy = createShape
#   shp_gridxy.beginShape(LINES)
#   shp_gridxy.stroke(0)
#   shp_gridxy.strokeWeight(1.0)
#   d = lines * s
#   (0..lines).each do |i|
#     shp_gridxy.vertex(-d, -i * s, 0)
#     shp_gridxy.vertex(d, -i * s, 0)
#     shp_gridxy.vertex(-d, +i * s, 0)
#     shp_gridxy.vertex(d, +i * s, 0)
#     shp_gridxy.vertex(-i * s, -d, 0)
#     shp_gridxy.vertex(-i * s, d, 0)
#     shp_gridxy.vertex(+i * s, -d, 0)
#     shp_gridxy.vertex(+i * s, d, 0)
#   end
#   shp_gridxy.endShape
#   shp_gridxy
# end

def print_camera
  pos = peasycam.get_position
  rot = peasycam.get_rotations
  lat = peasycam.get_look_at
  dis = peasycam.get_distance
  cam_format = '%s: (%7.3f, %7.3f, %7.3f)'
  dist_format = 'distance: (%7.3f)'
  puts format(cam_format, 'position', pos[0], pos[1], pos[2])
  puts format(cam_format, 'rotation', rot[0], rot[1], rot[2])
  puts format(cam_format, 'look_at', lat[0], lat[1], lat[2])
  puts format(dist_format, dis)
end

def key_released
  case key
  when '1', '2', '3', '4', '5'
    @aamode = AA_MODE[key]
  when 'q', 'w', 'e'
    @smaamode = SMAA_MODE[key]
  when 'c'
    print_camera
  end
end
