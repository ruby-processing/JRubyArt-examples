### Custom ContactListener example

This example is somewhat based on the CollisionListening example [Box2D for processing][] by Dan Shiffman, but with a CustomContact listener.  It uses the jruby way of implementing an interface (which is to `include` it as if it were a `module`). Note the use of the more elegant ruby way to discriminate between Boundary (has no `:change` method) and Particle (`responds_to? :change` method) objects.

[Box2D for processing]:https://github.com/shiffman/Box2D-for-Processing

