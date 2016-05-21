# After an original by Amon Owed
# USAGE: features constrained ArcBall and use of perspektiv method
# - drag the mouse horizontally to rotate horizontally around the y-axis
# - use the mouse wheel to zoom in and out
#
# WARNING: Mesh creation may take a while.
# load gem and import the required library
require 'geomerative' # for text manipulation and point extraction

load_library :hemesh
# create namespace for hemesh packages
module HE
  include_package 'wblut.hemesh' # for hemesh HE_Mesh class
  include_package 'wblut.geom' # for hemesh geometry classes
end

INPUT = 'TYPE' # the INPUT string that is transformed into a 3D mesh

attr_reader :text_shape

def settings
  size(1_280, 720, P3D) # of course we need the 3D renderer
  smooth(8) # nice and smooth! -)
end

def setup
  # Geomerative
  sketch_title 'Geomerative and Hemesh Type Sketch'
  ArcBall.constrain(self)
  RG.init(self) # initialize the Geomerative library
  RCommand.setSegmentator(RCommand::UNIFORMSTEP) # settings for the generated shape density
  RCommand.setSegmentStep(2) # settings for the generated shape density
  # create the font used by Geomerative using absolute path on ArchLinux
  font = RFont.new('/usr/share/fonts/TTF/FreeSans.ttf', 350, CENTER) 
  rmesh = font.toGroup(INPUT).toMesh # create a 2D mesh from a text
  # call the methods (see below) that do the actual work in this sketch
  mesh = rmesh_to_hemesh(rmesh) # create a 3D mesh from an INPUT string (using Geomerative & Hemesh)
  manipulate_mesh(mesh) # apply modifiers to the HE::HE_Mesh to subdivide and distort it
  mesh = color_faces(mesh) # color the faces of the generated mesh using a bit of custom code
  @text_shape = hemesh_to_pshape(mesh) # store the HE::HE_Mesh in a PShape for fast display on the GPU
end

def draw
  background(255) # clear the background
  perspektiv(near_z: 1, far_z: 1_000_000) # wide clipping planes
  lights
  directional_light(255, 255, 255, 1, 1, -1) # custom lights for more contrast
  directional_light(127, 127, 127, -1, -1, 1) # custom lights for more contrast
  shape(text_shape) # display the text PShape
end

# convert a RMesh into a 3D HE::HE_Mesh
def rmesh_to_hemesh(rmesh)
  puts 'Creating mesh.'
  triangles = []  # holds the original 2D text mesh
  triangles_flipped = []  # holds the flipped 2D text mesh
  # extract the triangles from geomerative's 2D text mesh, then place them
  # as hemesh's 3D HE::WB_Triangle's in their respective lists (normal & flipped)
  rmesh.strips.each do |strip|
    pnts = strip.get_points
    (2...pnts.length).each do |j|
      a = HE::WB_Point.new(pnts[j-2].x, pnts[j-2].y, 0)
      b = HE::WB_Point.new(pnts[j-1].x, pnts[j-1].y, 0)
      c = HE::WB_Point.new(pnts[j].x, pnts[j].y, 0)
      t = j.even? ? HE::WB_Triangle.new(a, b, c) : HE::WB_Triangle.new(c, b, a)
      tFlipped = j.even? ? HE::WB_Triangle.new(c, b, a) : tFlipped = HE::WB_Triangle.new(a, b, c)
      # add the original and the flipped triangle (to close the 3D shape later on) to their respective lists
      triangles << t
      triangles_flipped << tFlipped
    end
  end
  tmesh = HE::HE_Mesh.new(HE::HEC_FromTriangles.new.setTriangles(triangles))
  tmesh.modify(HE::HEM_Extrude.new.setDistance(100))
  tmesh.add(HE::HE_Mesh.new(HE::HEC_FromTriangles.new.setTriangles(triangles_flipped)))
  tmesh.clean
  tmesh
end

# manipulate the mesh 
def manipulate_mesh(mesh)
  puts 'Modifying mesh.'
  # A random selection + order of subdividers & modifiers -)
  mesh.subdivide(HE::HES_CatmullClark.new) # subdivide all
  mesh.subdivide_selected(HE::HES_CatmullClark.new, random_selection(mesh, 0.05)) # subdivide selection
  mesh.modifySelected(HE::HEM_VertexExpand.new.setDistance(10), random_selection(mesh, 0.10)) # vertex expand selection
  mesh.modifySelected(HE::HEM_Extrude.new.setDistance(15).setRelative(true).setChamfer(0.55), random_selection(mesh, 0.2)) # extrude selection
  mesh.modifySelected(HE::HEM_Extrude.new.setDistance(10).setRelative(true).setChamfer(0.75), random_selection(mesh, 0.1)) # extrude selection
  mesh.subdivide_selected(HE::HES_CatmullClark.new, random_selection(mesh, 0.05)) # subdivide selection
end

# get a random selection of faces from the mesh, given a certain threshold
def random_selection(mesh, threshold)
  selection = HE::HE_Selection.new(mesh)
  mesh.getFacesAsArray.each do |face|
    selection.add(face) if rand < threshold
  end
  selection
end

# color each face in the mesh based on it's xy-position using hsb_color method
def color_faces(mesh)
  mesh.getFacesAsArray.each do |face|
    c = face.getFaceCenter
    face.setLabel(hsb_color(map1d(c.xf + c.yf, -500..500, 0.12..0.70), 0.65, 1.0))
  end
  mesh
end

# store the geometry from a HE::HE_Mesh in a PShape for quick display on the GPU
def hemesh_to_pshape(mesh)
  puts 'Triangulating mesh.'
  mesh.triangulate # ensure it's triangles only (CPU-intensive, but necessary)

  # get all the shape data from the HE::HE_Mesh
  faces_hemesh = mesh.getFacesAsInt
  vertices_hemesh = mesh.getVerticesAsFloat
  face_array = mesh.getFacesAsArray
  puts 'Storing mesh in PShape.'
  # create a PShape from the HE::HE_Mesh shape data
  tshape = create_shape
  tshape.begin_shape(TRIANGLES)
  tshape.stroke(0, 125)
  tshape.stroke_weight(0.5)
  faces_hemesh.length.times do |i|
    tshape.fill(face_array[i].getLabel)
    3.times do |j|
      index = faces_hemesh[i][j]
      vertex_hemesh = vertices_hemesh[index]
      tshape.vertex(vertex_hemesh[0], vertex_hemesh[1], vertex_hemesh[2])
    end
  end
  tshape.end_shape
  puts 'Done'
  # return the PShape
  tshape
end
