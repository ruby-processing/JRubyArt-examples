### Source of Sketches

These sketches have been translated from 'vanilla processing sketches' by Dan Shiffman.  The original sketches were designed to run with the Box2D-for-processing library which has a subtlely different interface from the pbox2d gem. There is probably scope for further refactoring of most of the sketches to make them more ruby-like (the mouse_joint example has perhaps travelled furthest from the original version). 

### java_args.txt

The `data` folder contains java_args.txt, which currently silently enables the OpenGl-based pipeline using `-Dsun.java2d.opengl=true` add any other java args here, use `True` instead of `true` to get a message.
