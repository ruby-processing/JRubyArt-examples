class MouseThing < LibraryProxy
attr_reader :app, :count
  def initialize(app)
    @app = app
    @count = 0
  end

  def draw
  end

  def mouseEvent(event)
    case event.action
    when MouseEvent::CLICK
      fstring = 'CLICK at x = %.1f, y = %.1f'
      puts format(fstring, event.x, event.y)
    when MouseEvent::DRAG
      puts 'DRAG'
    when MouseEvent::WHEEL
      @count += event.getCount
      puts count
    end
  end
end
