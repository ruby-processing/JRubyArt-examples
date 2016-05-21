# From the Processing Examples
# by Zach Lieberman

WORDS = %w(sometimes\ it's\ like the\ lines\ of\ text are\ so\ happy
           that\ they\ want\ to\ dance or\ leave\ the\ page\ or\ jump
           can\ you\ blame\ them? living\ on\ the\ page\ like\ that
           waiting\ to\ be\ read...)

def setup
  sketch_title 'Kinetic Type'
  frame_rate 30
  # Load the font from the sketch's data directory.
  text_font load_font('Univers45.vlw'), 1.0
  fill 255
  # Creating the line objects
  @lines = WORDS.map.with_index { |word, i| Line.new(self, word, 0, i * 70) }
end

def draw
  background 0
  translate(-240, -120, -450)
  rotate_y 0.3
  # Now animate every line object & draw it...
  @lines.each_with_index do |line, i|
    push_matrix
    translate 0.0, line.ypos, 0.0
    line.draw(i)
    pop_matrix
  end
end

class Line
  attr_accessor :app, :string, :xpos, :ypos, :letters

  def initialize(app, string, x, y)
    @app, @string, @xpos, @ypos = app, string, x, y
    spacing = 0.0
    @letters = string.split('').map do |c|
      spacing += app.text_width(c)
      Letter.new(c, spacing, 0.0)
    end
  end

  def compute_curve(line_num)
    base = app.millis / 10_000.0 * Math::PI * 2
    Math.sin((line_num + 1.0) * base) * Math.sin((8.0 - line_num) * base)
  end

  def draw(line_num)
    curve = compute_curve(line_num)
    letters.each_with_index do |letter, i|
      return if i < 0
      app.translate(app.text_width(letters[i - 1].char) * 75, 0.0, 0.0)
      app.rotate_y(curve * 0.035)
      app.push_matrix
      app.scale(75.0, 75.0, 75.0)
      app.text(letter.char, 0.0, 0.0)
      app.pop_matrix
    end
  end
end

Letter = Struct.new(:char, :x, :y)

def settings
  size(200, 200, P3D)
end
