### READ ME ###

It is an unfortunate fact that queasycam uses `processing.core.PVector` under the hood, this does not play too well with JRubyArt the decent thing would be to create an interface? The use of `java.awt.Robot` under the hood may also be somewhat dodgy, especially since all exceptions get ignored (_the constructor is expected to throw security exception on X windows_). It might be interesting what could be done in `pure` ruby well at least using `Vec3D` instead of `PVector`.
