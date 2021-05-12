%w[PGS_Morphology PGS_Transformation].each do |klass|
  java_import "micycle.pgs.#{klass}"
end

class Letter
  include Processing::Proxy
  attr_reader :hue, :l, :xn, :yn, :pos, :letter

  def initialize(c)
    @pos = Vec2D.new(rand(width), rand(height))
    list = Java::ProcessingCore::PFont.list.to_a
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
    random_font = list.sample
    font = createFont(random_font, 128, true)
    @l = font.getShape(rand(0..9).to_s.to_java(:char))
  end
end
