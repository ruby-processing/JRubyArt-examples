load_library :pgs
%w[
  PGS_Contour PGS_Conversion PGS_Morphology PGS_Transformation PGS_ShapeBoolean
].each do |klass|
  java_import "micycle.pgs.#{klass}"
end

class Letter
  include Processing::Proxy

  attr_reader :hue, :l, :xn, :yn, :pos, :letter, :serif

  def initialize(c)
    @pos = Vec2D.new(rand(width), rand(height))
    list = Java::ProcessingCore::PFont.list.to_a
    @serif = list.select { |fon| fon =~ /Serif/i }
    random_font = list.sample
    font = createFont(random_font, 96, true)
    @l = font.get_shape(c.to_java(:char))
    @hue = rand
    @xn = rand(4096)
    @yn = rand(4096)
  end

  def update
    @xn += 0.005
    @yn += 0.005
    pos.x = map1d(noise(xn), -1.0..1.0, 0..width)
    pos.y = map1d(noise(yn), -1.0..1.0, 0..height)
    @letter = PGS_Transformation.translate_to(l, 0, 0)
    @letter = PGS_Transformation.shear(letter,
      map1d(@pos.x, 0..width, -TWO_PI..TWO_PI),
      map1d(@pos.y, 0..height, -TWO_PI..TWO_PI)
    )
    @letter = PGS_Transformation.translate_to(letter, pos.x, pos.y)
    @letter = PGS_Morphology.simplify(letter, 1) # as some fonts have very dense vertices
    letter.setStroke(color(hue, 1, 1))
  end

  def randomise
    @hue = rand
    list = Java::ProcessingCore::PFont.list.to_a
    random_font = serif.sample
    font = createFont(random_font, 128, true)
    @l = font.getShape(rand(0..9).to_s.to_java(:char))
  end
end


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
    # puts e.to_s
  end
  if (frame_count % 120).zero?
    l1.randomise
    l2.randomise
  end
end

def settings
  size(800, 800)
end
