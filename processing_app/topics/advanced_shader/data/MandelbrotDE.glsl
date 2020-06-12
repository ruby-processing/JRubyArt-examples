//jscottpilgrim
//distance estimator
//distance estimation info: http://www.iquilezles.org/www/articles/distancefractals/distancefractals.htm

//fragment shader

#ifdef GL_ES
precision highp float;
precision mediump int;
#endif

uniform vec2 resolution;

uniform vec2 center;
uniform float zoom;

const int maxIterations = 1000;

vec2 complexSquare( vec2 v ) {
	return vec2(
		v.x * v.x - v.y * v.y,
		v.x * v.y * 2.0
	);
}


void main()
{
	vec2 uv = gl_FragCoord.xy - resolution.xy * 0.5;
	
	bool escape = false;
	vec2 z = vec2( 0.0 );
	vec2 dz = vec2( 0.0 );
	vec2 c = uv * zoom + center;

	for ( int i = 0 ; i < maxIterations; i++ ) {
		//z' = 2 * z * z'+ 1
		dz = 2.0 * vec2( z.x * dz.x - z.y * dz.y, z.x * dz.y + z.y * dz.x ) + vec2( 1.0, 0.0 );

		//mandelbrot function on z
		z = c + complexSquare( z );

		//higher escape radius for detail, 32^2
		if ( dot( z, z ) > 1024.0 )
		{
			escape = true;
			break;
		}
	}

	vec3 color = vec3( 1.0 );

	if ( escape )
	{
		//distance
		//d(c) = (|z|*log|z|)/|z'|

		//idk why inigo uses this formula. optimization of distance estimation?
		//float d = 0.5*sqrt(dot(z,z)/dot(dz,dz))*log(dot(z,z));

		float d = sqrt( dot( z, z ) );
		d *= log( sqrt( dot( z, z ) ) );
		d /= sqrt( dot( dz, dz ) );

		d = clamp( pow( 4.0 * d, 0.1 ), 0.0, 1.0 );

		color = vec3( d );
	}
	else
	{
		//set inside points to inside color
		color = vec3( 0.0 );
	}

	gl_FragColor = vec4( color, 1.0 );
}