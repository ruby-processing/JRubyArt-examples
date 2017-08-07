class MouseThing < LibraryProxy
  def draw
  end

  def mouseEvent(event)
    case event.action
    when MouseEvent::CLICK
      puts 'CLICK'
    when MouseEvent::DRAG
      puts 'DRAG'
    end
  end
end
