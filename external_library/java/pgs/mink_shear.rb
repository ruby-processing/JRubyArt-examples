load_library :pgs
%w[
  PGS_Contour PGS_Conversion PGS_Morphology PGS_Transformation PGS_ShapeBoolean
].each do |klass|
  java_import "micycle.pgs.#{klass}"
end
require_relative 'letter'

attr_reader :l1, :l2

def setup
  sketch_title 'Mink Shear'
  color_mode(HSB, 1.0)
  @l1 = Letter.new('M')
  @l2 = Letter.new('L')
end

def draw
  fill(color(0.1, 0.2))
  rect(0, 0, width, height)
  begin
    l1.update
    l2.update
    mink = PGS_Morphology.mink_sum(l1.letter, l2.letter)
    mink = PGS_Transformation.translate_to(mink, (l1.pos.x + l2.pos.x) / 2, (l1.pos.y + l2.pos.y) / 2)
    shape(mink)
    shape(l1.letter)
    shape(l2.letter)
    shape(PGS_Contour.medialAxis(mink, 0.3, 0, 0.1))
    intersect = PGS_ShapeBoolean.intersect(l1.letter, mink)
    PGS_Conversion.setAllFillColor(intersect, color(0, 0.5))
    shape(intersect)
    intersect = PGS_ShapeBoolean.intersect(l2.letter, mink)
    PGS_Conversion.setAllFillColor(intersect, color(0, 0.5))
    shape(intersect)
  rescue Java::JavaLang::Exception => e
    puts e.to_s
  end
  if (frame_count % 120).zero?
    l1.randomise
    l2.randomise
  end
end

def settings
  size(800, 800)
end
