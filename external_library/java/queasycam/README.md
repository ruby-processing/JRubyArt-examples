### READ ME ###

It is an unfortunate fact that queasycam uses PVector under the hood, this does not play too well with JRubyArt the decent thing would be create an interface? Use of `java.awt.Robot` under the hood may also be somewaht dodgy, especially since all exceptions get ignored (expected to throw security exception on X windows). It might be ineresting waht could be done in `pure` ruby well at least using `Vec3D` instead of `PVector`.
