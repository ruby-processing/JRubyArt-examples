#!/usr/bin/env jruby
require 'propane'

class ColorPresets < Propane::App

  load_library :hype
  include_package 'hype'
  java_import 'hype.extended.layout.HGridLayout'
  # string color array
  PALETTE = %w(
    CLEAR
    WHITE
    BLACK
    LGREY
    GREY
    DGREY
    RED
    GREEN
    BLUE
    CYAN
    YELLOW
    MAGENTA
  ).freeze
  # format string see fill below
  FSTRING = 'Java::HypeInterfaces::HConstants::%s'.freeze

  def settings
    size(640, 640)
  end

  def setup
    sketch_title 'Color Presets'
    H.init(self)
    H.background(color('#242424'))
    grid = HGridLayout.new(3).spacing(210, 157).start_loc(10, 10)
    PALETTE.each do |col|
      H.add(HRect.new(200, 147))
       .stroke_weight(3)
       .stroke(H::BLACK, 150.0) # Note we call hype constants
       .fill(instance_eval(format(FSTRING, col))) # and using eval
       .loc(grid.get_next_point)
    end
  end

  def draw
    H.draw_stage
    no_loop
  end
end

ColorPresets.new
