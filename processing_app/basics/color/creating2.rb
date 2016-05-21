# encoding: utf-8
# frozen_string_literal: true
# Creating Colors (Homage to Albers).
#
# Creating variables for colors that may be referred to
# in the program by their name, rather than a number.
# An alternative using palette
attr_reader :palette
WEB = %w(#CC6600 #CC9900 #993300).freeze
REDDER = 0
YELLOWER = 1
ORANGISH = 2

def setup
  sketch_title 'Homage to Albers'
  @palette = web_to_color_array(WEB)
end

def draw
  no_stroke
  background 51, 0, 0
  push_matrix
  translate 80, 80
  fill palette[ORANGISH]
  rect 0, 0, 200, 200
  fill palette[YELLOWER]
  rect 40, 60, 120, 120
  fill palette[REDDER]
  rect 60, 90, 80, 80
  pop_matrix
  push_matrix
  translate 360, 80
  fill palette[REDDER]
  rect 0, 0, 200, 200
  fill palette[ORANGISH]
  rect 40, 60, 120, 120
  fill palette[YELLOWER]
  rect 60, 90, 80, 80
  pop_matrix
end

def settings
  size 640, 360, FX2D
end
