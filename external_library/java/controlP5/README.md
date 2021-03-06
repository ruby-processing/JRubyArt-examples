### About ControlP5 library

This library was developed by [Andreas Schlegel][sojamo] http://www.sojamo.de/ over a number of years (9+) and this is why controlP5's source code so convoluted and bloated see [github][p5]. However this has not deterred people from using the code, and it remains a very popular gui for processing, some of the callback features do not play well with JRubyArt or propane. Here I explore approaches that do work, mainly for use with Thomas Diewalds PixelFlow library (that heavily uses the ControlP5 library). Before going on to explore the jruby alternative to ControlP5, [Skatoloo][skatolo] by Jeremy Laviole (aka poqudrof).

So far I have found that buttons are most easily connected using individual listeners. For other controllers such as radio buttons, sliders, these are most easily accessed via the controller interface and the `controlEvent(event)` method:-

```ruby
cp5.add_button('reset')
   .set_group(group_fluid)
   .set_size(80, 18)
   .set_position(px, py)
   .add_listener { reset! } # add listener direct to button
```
Using the ControllerInterface is as simple as
```ruby

include ControlListener

# Them defining the `controlEvent(event)` method

def controlEvent(event)
  if event.group?
    ...
  elsif event.controller?
    case event.get_controller.get_name
    when 'velocity'
      fluid.param.dissipation_velocity = event.get_controller.get_value
    ...
end

```
[sojamo]:http://www.sojamo.de/
[p5]:https://github.com/sojamo/controlp5
[skatolo]:https://github.com/Rea-lity-Tech/Skatolo
