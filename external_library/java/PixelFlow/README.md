### PixelFlow examples

Requires peascam library

Note how we can implement callbacks in jruby with a ruby lambda

__processing__
```java
// callback for rendering the scene
DwSceneDisplay scene_display = new DwSceneDisplay(){
  @Override
  public void display(PGraphics3D canvas) {
    displayScene(canvas);  
  }
};
```

__JRubyArt__
```ruby
# callback for rendering scene, implements DwSceneDisplay interface
scene_display = lambda do |canvas|
  canvas.background(32) if canvas == skylight.renderer.pg_render
  canvas.shape(shape)
end
```
