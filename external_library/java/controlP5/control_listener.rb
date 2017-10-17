load_library :controlP5
java_import 'controlP5.ControlP5'
java_import 'controlP5.ControlListener'

include ControlListener

attr_reader :cp5

def settings
  size(800, 400)
end

def setup
  sketch_title 'Control Listener'
  @cp5 = ControlP5.new(self)
  g1 = cp5.addGroup('g1')
          .setPosition(100,100)
          .setBackgroundHeight(100)
          .setBackgroundColor(color(255,50))
  cp5.addBang('A-1')
     .setPosition(10,20)
     .setSize(80,20)
     .setGroup(g1)
  cp5.addBang('A-2')
     .setPosition(10,60)
     .setSize(80,20)
     .setGroup(g1)
  g2 = cp5.addGroup('g2')
          .setPosition(250,100)
          .setWidth(300)
          .activateEvent(true)
          .setBackgroundColor(color(255,80))
          .setBackgroundHeight(100)
          .setLabel('Hello World.')
  cp5.addSlider('S-1')
     .setPosition(80,10)
     .setSize(180,9)
     .setGroup(g2)
  cp5.addSlider('S-2')
     .setPosition(80,20)
     .setSize(180,9)
     .setGroup(g2)
  cp5.addRadioButton('radio')
     .setPosition(10,10)
     .setSize(20,9)
     .addItem('black',0)
     .addItem('red',1)
     .addItem('green',2)
     .addItem('blue',3)
     .addItem('grey',4)
     .setGroup(g2)
  g3 = cp5.addGroup('g3')
          .setPosition(600,100)
          .setSize(150,200)
          .setBackgroundColor(color(255,100))
  cp5.addScrollableList('list')
     .setPosition(10,10)
     .setSize(130,100)
     .setGroup(g3)
     .addItems ('a'..'g').to_a
end

def draw
  background(0)
end

def controlEvent(event)
  group_format = 'got event from group %s, isOpen? %s'
  control_format = 'got event from a controller %s'
  if event.group?
    puts(format(group_format, event.getGroup.getName, event.getGroup.isOpen))
  elsif event.controller?
    puts(format(control_format, event.getController.getName))
  end
end
