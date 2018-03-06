# proxy_library.rb
# LibraryProxy is an AbstractJava class to give us access to the java
# reflection methods 'pre', 'post' and 'draw' (latter we should implement)
# also mouseEvent(e) and keyEvent(e) NB: need camel-case for reflection
# width, height, fill, stroke, background are available, otherwise use app.
class TestProxy < LibraryProxy # subclass LibraryProxy
  # draw is abstract, empty method would be OK
  def draw
    fill 200
    app.ellipse(width / 2, height / 2, 20, 20)
  end

  # def mouseEvent(e)
  #   use e in block to access MouseEvent
  # end  
end
