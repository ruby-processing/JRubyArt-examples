## Contributing JRubyArt examples

Share your enthusiasm for coding by submitting an example for inclusion here, provisional versions are acceptable if they demonstrate something interesting (and work), but we would prefer that you followed the style guide. But naturally we expect that you to aspire to the principal of code as art eventually (not many original examples survive without amendment).

### Style guide

* Prefer [bare sketches][bare] over [class wrapped][class].
* Prefer `Vec2D` and `Vec3D` to `PVector` (it is confusing and sometimes plain wrong).
* Prefer `Struct` over `Vec2D` and `Vec3D` if you don't need their methods.
* No trailing whitespace.
* Use spaces not tabs.
* Avoid explicit return statements.
* Avoid using semicolons.
* Don't use `self` explicitly anywhere except class methods (`def self.method`)
  and assignments (`self.attribute =`).
* Prefer `&:method_name` to `{ |item| item.method_name }` for simple method
  calls.
* Use `CamelCase` for classes and modules, `snake_case` for variables and
  methods, `SCREAMING_SNAKE_CASE` for constants.
* Use `def self.method`, not `def Class.method` or `class << self`.
* Use `def` with parentheses when there are arguments.
* Don't use spaces after required keyword arguments.
* Use `each`, not `for`, for iteration.

When translating a sketch from vanilla processing (or some other codebase), you should credit the original author, unless the rubified version is unrecognizable from the original.  It is often worth running `rubocop` on sketch code to avoid the most egregious errors.

[bare]:http://ruby-processing.github.io/projects/jruby_art/
[class]:http://ruby-processing.github.io/projects/jruby_art/
