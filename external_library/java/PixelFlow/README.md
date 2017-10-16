### PixelFlow examples

Requires peascam library

Note how we can implement callbacks in jruby with a ruby lambda in skylight_basic.rb

__processing__
```java
// callback for rendering the scene
DwSceneDisplay scene_display = new DwSceneDisplay(){
  @Override
  public void display(PGraphics3D canvas) {
    displayScene(canvas);  
  }
};

public void displayScene(PGraphics canvas){
  if(canvas == skylight.renderer.pg_render){
    canvas.background(32);
  }
  canvas.shape(shape);
}

// init skylight renderer
   skylight = new DwSkyLight(context, scene_display, mat_scene_bounds);
```

__JRubyArt__

```ruby
# callback for rendering scene, implements DwSceneDisplay interface
scene_display = lambda do |canvas|
  canvas.background(32) if canvas == skylight.renderer.pg_render
  canvas.shape(shape)
end

# init skylight renderer
@skylight = DwSkyLight.new(context, scene_display, mat_scene_bounds)
```

In __antialiasing.rb__ if we just use the overloaded `color` method, jruby complains of overloaded method but guesses right and chooses the correct java signature (float, float, float). Mainly to show how we can do it, we provide an alias method `color_float` that avoids the look up cost in detecting the correct signature, this is not generally important if you can put up with the warning.


The ControlP5 library is overly complicated and does not seem to work well with JRubyArt, the built in `control_panel` is much simpler to use. If you must use ControlP5 see [examples][p5]


[p5]:https://github.com/ruby-processing/JRubyArt-examples/tree/master/external_library/java/controlP5
