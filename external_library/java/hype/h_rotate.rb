# encoding: utf-8
load_library :hype
include_package 'hype'
java_import 'hype.extended.behavior.HRotate'
attr_reader :box_x, :box_y, :box_z, :colors
PALETTE = %w(#242424 #FF3300 #00CC00).freeze

def settings
  size(640, 640, P3D)
end

def setup
  sketch_title 'HRotate'
  H.init(self)
  @colors = web_to_color_array(PALETTE)
  H.background(colors[0])
  H.use3D(true)
  # rotate on the x axis
  H.add(@box_x = HBox.new).size(75).no_stroke.fill(colors[1]).loc((width / 2) - 175, height / 2)
  HRotate.new.target(box_x).speed_x(1).speed_y(0).speed_z(0)
  # rotate on the y axis
  H.add(@box_y = HBox.new).size(75).no_stroke.fill(colors[1]).loc(width / 2, height / 2)
  HRotate.new.target(box_y).speed_x(0).speed_y(1).speed_z(0)
  # rotate on the z axis
  H.add(@box_z = HBox.new).size(75).no_stroke.fill(colors[1]).loc((width / 2) + 175, height / 2)
  HRotate.new.target(box_z).speed_x(0).speed_y(0).speed_z(1)
end

def draw
  lights
  H.draw_stage
  # visualize axis rotation rods
  no_fill
  stroke(colors[2])
  line((width / 2) - (175 + 75), height / 2, 0, (width / 2) - (175 - 75), height / 2, 0) # x axis
  line(width / 2, (height / 2) - 75, 0, width / 2, (height / 2) + 75, 0) # y axis
  line((width / 2) + 175, height / 2, -100 ,(width / 2) + 175, height / 2, + 100) # z axis
end
