# Sketch to demonstrate the use of colour tables. A ColourTable object
# consists of a set of ColourRules. Each rule maps a numeric value to
# a colour. The colour to be associated with any value can be found by
# calling the find_colour method of a colour table. If the rules are
# continuous, the returned colour is interpolated between the two
# colour rules closest to the given value. If rules are discrete, only
# exact matches are mapped to a colour.
# Version 1.2, 4th November, 2013.
# Author Jo Wood. Adapted for JRubyArt by Martin Prout 2019
load_library 'gicentreUtils'
java_import 'org.gicentre.utils.colour.ColourTable'

attr_reader :table1, :table2, :table3 # Colour tables to use.

def settings
  size(500, 250)
end

def setup
  sketch_title('GiCentre ColourTable Example in JRubyArt')
  # Create a continuous Brewer colour table (YlOrBr6).
  @table1 = ColourTable.new
  table1.add_continuous_colour_rule(0.5 / 6, 255, 255, 212)
  table1.add_continuous_colour_rule(1.5 / 6, 254, 227, 145)
  table1.add_continuous_colour_rule(2.5 / 6, 254, 196, 79)
  table1.add_continuous_colour_rule(3.5 / 6, 254, 153, 41)
  table1.add_continuous_colour_rule(4.5 / 6, 217, 95, 14)
  table1.add_continuous_colour_rule(5.5 / 6, 153, 52, 4)
  # Create a preset colour table and save it as a file
  @table2 = ColourTable.get_preset_colour_table(ColourTable::IMHOF_L3, 0, 1)
  ColourTable.write_file(table2, create_output(data_path('imhofLand3.ctb')))
  # Read in a colour table from a ctb file.
  @table3 = ColourTable.read_file(create_input(data_path('imhofLand3.ctb')))
end

def draw
  background(255)
  # Draw the continuous Brewer colour table.
  draw_color_table(table1, 0.001, 10)
  # Draw the discrete version of the Brewer colour table.
  draw_color_table(table1, 1 / 6.0, 70, true)
  # Draw the preset colour table.
  draw_color_table(table2, 0.001, 130)
  # Draw the colour table loaded from a file.
  draw_color_table(table3, 1 / 6.0, 190)
end

def draw_color_table(table, increment, height, outline = false)
  (0..1.0).step(increment) do |i|
    fill(table.find_colour(i))
    outline ? stroke(0, 150) : stroke(table.find_colour(i))
    rect(width * i, height, width * increment, 50) unless outline
    rect(width * i, height, width * increment, 50, 2) if outline
  end
end
