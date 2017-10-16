java_import 'controlP5.ControlP5'

class Gui
  include Processing::Proxy
  attr_reader :app, :cp5
  def initialize(app)
    @app = app
    @cp5 = ControlP5.new(app)
    cp5.addSlider("v1")
	     .setPosition(40, 40)
	     .setSize(200, 20)
	     .setRange(100, 300)
	     .setValue(250)
	     .setColorCaptionLabel(color(20,20,20))
  end

  def v1
    cp5.getValue("v1")
  end
end
