load_library :controlP5
include_package 'controlP5'

attr_reader :r1, :back_color

def settings
  size(700,400)
end

def setup
  sketch_title 'Radio Buttons'
  @back_color = color(0, 0, 0)
  cp5 = ControlP5.new(self)
  @r1 = cp5.addRadioButton('radioButton')
  .setPosition(100,180)
  .setSize(40,20)
  .setColorForeground(color(120))
  .setColorActive(color(255))
  .setColorLabel(color(255))
  .setItemsPerRow(5)
  .setSpacingColumn(50)
  .addItem('fish', 1)
  .addItem('toad', 2)
  .addItem('apricot', 3)
  .addItem('peach', 4)
  .addItem('plum', 5)
  r1.getItems.each do |t|
    t.getCaptionLabel.setColorBackground(color(255,80))
    t.getCaptionLabel.getStyle.moveMargin(-7,0,0,-3)
    t.getCaptionLabel.getStyle.movePadding(7,0,0,3)
    t.getCaptionLabel.getStyle.backgroundWidth = 45
    t.getCaptionLabel.getStyle.backgroundHeight = 13
  end
end

def draw
  background(back_color)
end

def key_pressed
  case(key)
  when('1')
    puts "fish selected #{r1.getState('fish')}"
  when('2')
    puts "toad selected #{r1.getState('toad')}"
  when('3')
    puts "apricot selected #{r1.getState('apricot')}"
  when('4')
    puts "peach selected #{r1.getState('peach')}"
  else
    puts "plum selected #{r1.getState('plum')}"
  end
end
