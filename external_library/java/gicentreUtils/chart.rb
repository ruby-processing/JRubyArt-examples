# encoding: utf-8
# frozen_string_literal: true
load_library :gicentreUtils
include_package 'org.gicentre.utils.stat' # For chart classes.

# Demonstrates the use of the BarChart class to draw simple bar charts.
# Version 1.3, 6th February, 2016.
# Author Jo Wood, giCentre. Translated to JRubyArt by Martin Prout

# --------------------- Sketch-wide variables ----------------------
attr_reader :bar_chart, :title_font, :small_font

# ------------------------ Initialisation --------------------------
LEGEND = 'Gross domestic product measured in inflation-corrected $US'.freeze
TITLE = 'Income per person, United Kingdom'.freeze

def settings
  size(800, 300)
  smooth 8
end

def setup
  sketch_title 'Bar Chart in JRubyArt'
  no_loop
  @title_font = create_font('helvetica', 22)
  @small_font = create_font('helvetica', 12)
  text_font(small_font)
  @bar_chart = BarChart.new(self)
  bar_chart.data =
    [
      2_462, 2_801, 3_280, 3_983, 4_490, 4_894, 5_642, 6_322, 6_489, 6_401,
      7_657, 9_649, 9_767, 12_167, 15_154, 18_200, 23_124, 28_645, 39_471
    ].to_java(:float)
  bar_chart.bar_labels =
    %w(
      1830 1840 1850 1860 1870 1880 1890 1900 1910 1920
      1930 1940 1950 1960 1970 1980 1990 2000 2010
    )
  bar_chart.bar_colour = color(200, 80, 80, 100)
  bar_chart.bar_gap = 2
  bar_chart.value_format = '$###,###'
  bar_chart.show_value_axis(true)
  bar_chart.show_category_axis(true)
end

# ------------------ Processing draw loop -------------------

# Draws the graph in the sketch.
def draw
  background(255)
  bar_chart.draw(10, 10, width - 20, height - 20)
  fill(120)
  text_font(title_font)
  text(TITLE, 70, 30)
  vertical_spacing = 30 + text_ascent # add the current text height
  text_font(small_font)
  text(LEGEND, 70, vertical_spacing)
end
