# fractions.rb, by Martin Prout
attr_reader :f, :two, :three, :four, :five, :six, :subtract, :multiply

def setup
  sketch_title 'Math Blackboard'
  @f = createFont('Arial', 24, true)
  half = 1 / 2r     # since ruby 2.1.0 (and jruby-9.0.0.0)
  third = 1 / 3r     
  quarter = 1 / 4r
  fifth = 1 / 5r
  sixth = 1 / 6r
  seventh = 1 / 7r
  format2 = '%s + %s                                     = %s'
  format3 = '%s + %s + %s                            = %s'
  format4 = '%s + %s + %s + %s                   = %s'
  format5 = '%s + %s + %s + %s + %s          = %s'
  format6 = '%s + %s + %s + %s + %s + %s = %s'
  sum2 =  half + third
  result2 = numeric_to_mixed_number(sum2)
  @two = format(format2, half, third, result2)
  sum3 =  half + third + quarter
  result3 = numeric_to_mixed_number(sum3)
  @three = format(format3, half, third, quarter, result3)
  sum4 =  half + third + quarter + fifth
  result4 = numeric_to_mixed_number(sum4)
  @four = format(format4, half, third, quarter, fifth, result4)
  sum5 =  half + third + quarter + fifth + sixth
  result5 = numeric_to_mixed_number(sum5)
  @five = format(format5, half, third, quarter, fifth, sixth, result5)
  sum6 =  half + third + quarter + fifth + sixth + seventh
  result6 = numeric_to_mixed_number(sum6)
  @six = format(format6, half, third, quarter, fifth, sixth, seventh, result6)
end

def draw
  background 10
  text_font(f, 24)
  fill(220)
  text('Math Blackboard JRubyArt', 110, 50)
  text(two, 80, 80)
  text(three, 80, 105)
  text(four, 80, 130)
  text(five, 80, 155)
  text(six, 80, 180)
end

def numeric_to_mixed_number(amount)
  amount_as_integer = amount.to_i
  if (amount_as_integer != amount.to_f) && (amount_as_integer > 0)
    fraction = amount - amount_as_integer
    format('%s %s', amount_as_integer, fraction)
  else
    amount.to_s
  end
end

def settings
  size 700, 240
end
