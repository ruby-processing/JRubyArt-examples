require 'toxiclibs'

# A 3D Tentacle by Nikolaus Gradwohl http://www.local-guru.net
# Adapted for JRubyArt and mesh to PShape, and mesh2 export by Martin Prout

attr_reader :mesh, :gfx, :tentacle

def settings
  size(500, 500, P3D)
end

def setup
  sketch_title 'Tentacle'
  ArcBall.init(self)
  @gfx = Gfx::MeshToVBO.new(self)
  volume = VolumetricSpaceArray.new(TVec3D.new(100, 200, 100), 100, 100, 100)
  surface = ArrayIsoSurface.new(volume)
  @mesh = TriangleMesh.new
  brush = RoundBrush.new(volume, 10)
  20.times do |i|
    brush.set_size(i * 1.2 + 6)
    x = cos(i * TWO_PI / 20) * 10
    y = sin(i * TWO_PI / 20) * 10
    brush.draw_at_absolute_pos(TVec3D.new(x, -25 + i * 7, y), 1)
  end
  (4..20).step(4) do |i|
    brush.set_size(i / 1.5 + 4)
    x = cos(i * TWO_PI / 20) * (i * 1.2 + 16)
    y = sin(i * TWO_PI / 20) * (i * 1.2 + 16)
    brush.draw_at_absolute_pos(TVec3D.new(x, -25 + i * 7, y), 1)
    brush.set_size(i / 2 + 2)
    x2 = cos(i * TWO_PI / 20) * (i * 1.2 + 18)
    y2 = sin(i * TWO_PI / 20) * (i * 1.2 + 18)
    brush.draw_at_absolute_pos(TVec3D.new(x2, -25 + i * 7, y2), -1.4)
  end
  volume.close_sides
  surface.reset
  surface.compute_surface_mesh(mesh, 0.5)
  no_stroke
  @tentacle = gfx.mesh_to_shape(mesh, true)
end

def draw
  background(150)
  define_lights
  shape(tentacle)
end

def define_lights 
  lights
  ambient_light(40, 40, 40)
  directional_light(10, 30, 40, 1, 1, 0)
  directional_light(10, 30, 40, 1, 1, -1)
end


def key_pressed
  case key
  when 'p', 'P'
    fileID = 'Tentacle'
    pm = Gfx::POVMesh.new(self)
    pm.begin_save(java.io.File.new(fileID + '.inc'))
    pm.set_texture(Gfx::Textures::RED)  # red with Phong texture
    pm.saveAsPOV(mesh, true)
    pm.end_save
    exit
  when 's', 'S'
    save_frame('Tentacle.png')
  end
end
