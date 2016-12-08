### Dealing with processing coordinate system ###

If you want to create Math Sketches in processing, you need to deal with peculiar coordinate systems, where the Y-axis is inverted in theory you should be able to do.

```ruby
scale(1, -1)
translate(0, -height)
```
But that will mess up any text (plus you probably need to `push_matrix` and `pop_matrix`) so it is probably simpler to create a parallel coordinate system for the math, and translate that back to the screen (using the processing `map` function or in `propane` and `JRubyArt` use `map1d`).

We have done this in `circumcircle_sketch.rb` or just accept the processing coordinate system as we have with `basic_cirmcumcircle_sketch.rb` (it is much simpler).
