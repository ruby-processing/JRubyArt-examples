
# Processings datatype conversion functions make no sense for Ruby as it does
# not have primitive datatypes. Try these instead:
# "to_s" (to String)
# "to_i" (to Integer, thats a Fixnum or Bignum)
# "to_f" (to Float, which would be "double" in Processing, not "float")
# "to_a" (to Array, i.e. from a Range or Hash)

def setup
  sketch_title 'Datatype Conversion'
  # Ruby has no primitive datatypes, everything is an object!
  # See:
  [1, 2.0, 'a', "B", nil, false].each do |element|
    puts
    puts "#{element.inspect} ... is a #{element.class.name} object"
  end
  
  c = 'A' # String (!) as there is no char datatype in Ruby.
  # Single quotes are parsed without substitutions (i.e. "It is #{Time.now}.")
  f = c.ord.to_f # Sets f = 65.0
  i = (f * 1.4).to_i # Sets i to 91
  b = (c.ord.to_i / 2) # Integer or FixNum as there is no byte in Ruby
  background 51
  no_stroke
  rect f, 0, 40, 66
  fill 204
  rect i, 67, 40, 66
  fill 255
  rect b, 134, 40, 66
end

def settings
  size 200, 200
end
