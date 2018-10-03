#Terreno
=begin
	Transcrito a Jruby_Art por Carlos Rocha
	Tomado de The Coding Train https://www.youtube.com/watch?v=IKB1hWWedMk
=end

class Terreno < Processing::App
	def settings
		size 800, 800, P3D
	end
	
	def setup
		sketch_title 'Terreno'
		@w = 1400
		@h = 1100
		@scl = 30
		@col = @w/@scl
		@filas = @h/@scl
		@terreno = {}
		@mover = 0
	end
	
	def draw
		background 0
		@mover -= 0.1
		yoff = @mover
		for y in 0..@filas
			xoff = 0
			for x in 0..@col
				@terreno["#{x}.#{y}"]= p5map noise(xoff,yoff), 0, 1, -65, 65 
				xoff += 0.2
			end
			yoff += 0.2
		end
		stroke 255
		no_fill
		stroke 235, 69,129
		translate width/2, height/2
		rotate_x PI/3
		translate -@w/2, -@h/2
		for y in 0..@filas-1
			begin_shape(TRIANGLE_STRIP)
				for x in 0..@col
					vertex(x*@scl, y*@scl, @terreno["#{x}.#{y}"])
					vertex(x*@scl,(y+1)*@scl, @terreno["#{x}.#{y+1}"])
				end
			end_shape(CLOSE)
		end
	end
end
