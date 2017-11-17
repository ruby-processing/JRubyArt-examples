# skatolo

### Skatolo is a GUI library for Processing, forked from [ControlP5](https://github.com/sojamo/controlp5)
See repo on [github](https://github.com/Rea-lity-Tech/Skatolo) to run these examples you require gem version 1.1.4+ (if only 1.1.3 version is available from rubygems then clone repo to build)

### About

The skatolo java library was developed for an [advanced use of ControlP5](https://github.com/poqudrof/PapARt), it is not as convenient to use. It is a part of a research and development project involving multi-touch, augmented reality and Ruby. However it has also been adapted to work easily with JRubyArt (and hence propane). The skatolo library is developed by [Jeremy Laviole](http://jeremy.laviole.name/).

#### Sliders

If you name slider 'fred' then you will be able access the value as `fred_value`

#### Buttons

If you name the button 'my_method' you will be able create a method `:my_method` that gets called when button is pressed.

### Usage

Sketches need to `require 'skatolo'`, and `include EventMethod`, otherwise usage is similar to ControlP5 except `Skatolo.new(self)` instead of `ControlP5.new(self)`
