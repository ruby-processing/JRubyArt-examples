# proxy_library.rb
# LibraryProxy is an AbstractJava class to give us access to the java
# reflection methods 'pre', 'post' and 'draw' (which we should implement)
# width, height, fill, stroke, background are available, otherwise use app.
class TestProxy < LibraryProxy # subclass LibraryProxy
  
  def pre; end # empty method is OK
     
  def draw
    fill 200
    app.ellipse(width / 2, height / 2, 20, 20)
  end
  
  def post; end # empty method is OK   
end
