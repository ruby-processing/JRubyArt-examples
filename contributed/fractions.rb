# fractions.rb, by Martin Prout
attr_reader :f, :add, :subtract, :multiply

def setup
  sketch_title 'Math Blackboard'
  @f = create_font('Arial', 24, true)
  third = 1 / 3r # since ruby 2.1.0 (and jruby-9.0.0.0)
  quarter = 1 / 4r
  format_add = '%s + %s = %s'
  format_sub = format_add.tr('+', '-')
  format_mult = format_add.tr('+', '*')
  @add = format(format_add, third, quarter, third + quarter)
  @subtract = format(format_sub, third, quarter, third - quarter)
  @multiply = format(format_mult, third, quarter, third * quarter)
end

def draw
  background 10
  text_font(f, 24)
  fill(220)
  text('Math Blackboard JRubyArt', 110, 50)
  text(add, 130, 100)
  text(subtract, 130, 150)
  text(multiply, 130, 200)
end

def settings
  size 640, 250
end
