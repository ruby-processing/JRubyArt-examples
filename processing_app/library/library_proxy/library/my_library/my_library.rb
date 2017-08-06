# This class demonstrates how by inheriting from the abstract class CustomProxy
# we can access 'keyEvent' and 'draw'  (Note we need a draw method even
# though can be empty)
class MyLibrary < LibraryProxy

  attr_reader :app

  def initialize(parent)
    @app = parent
  end

  def draw # optional
    fill app.color(200, 0, 0, 100) # partially transparent
    app.rect 100, 100, 60, 90
  end

  # favor guard clause no_op unless key pressed
  # and no_op unless ascii key else we can't use :chr
  def keyEvent(e) # NB: need camel case for reflection to work
    return unless e.get_action == KeyEvent::PRESS
    return if e.get_key >= 'z'.ord
    case e.get_key.chr.upcase
    when 'S'
      app.send :hide, false
    when 'H'
      app.send :hide, true
    else
      puts e.get_key.chr
    end
  end
end
