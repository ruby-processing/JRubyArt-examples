load_library :hemesh
include_package 'wblut.hemesh'
java_import 'wblut.processing.WB_Render'

attr_reader :selection, :invselection, :box, :render

def settings
  size(800, 800, P3D)
end

def setup
  sketch_title 'Mesh Selection'
  box_creator = HEC_Box.new.set_width(400)
                       .set_width_segments(10)
                       .set_height(200)
                       .set_height_segments(4)
                       .set_depth(200)
                       .set_depth_segments(4)
  @box = HE_Mesh.new(box_creator)
  ArcBall.init(self)
  # define a selection
  @selection = HE_Selection.new(box)
  # add faces to selection
  box.f_itr.each { |face| selection.add(face) if rand(100) < 50 }
  invselection = selection.get
  invselection.invert_faces
  cc = HES_CatmullClark.new.set_keep_edges(false).set_keep_boundary(false)
  # only modify selection (if applicable)
  selection.subdivide(cc, 2)
  # modifiers try to preserve selections whenever possible
  selection.modify(HEM_Extrude.new.set_distance(25).set_chamfer(0.4))
  invselection.modify(HEM_Extrude.new.set_distance(-5).set_chamfer(0.4))
  @render = WB_Render.new(self)
end

def draw
  background(25)
  lights
  fill(255)
  no_stroke
  render.draw_faces(box)
  fill(255, 0, 0)
  render.draw_faces(selection)
  stroke(0)
  render.draw_edges(box)
end
