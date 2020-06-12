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

const int maxIterations = 250;

//double precision not natively supported in webgl/gl_es
//emulated double precision from: https://gist.github.com/LMLB/4242936fe79fb9de803c20d1196db8f3
//performance drops dramatically from single precision. drop number of iterations to balance performance and max zoom. maybe ~300

float times_frc(float a, float b) {
	return mix(0.0, a * b, b != 0.0 ? 1.0 : 0.0);
}
float plus_frc(float a, float b) {
	return mix(a, a + b, b != 0.0 ? 1.0 : 0.0);
}
float minus_frc(float a, float b) {
	return mix(a, a - b, b != 0.0 ? 1.0 : 0.0);
}
// Double emulation based on GLSL Mandelbrot Shader by Henry Thasler (www.thasler.org/blog)
//
// Emulation based on Fortran-90 double-single package. See http://crd.lbl.gov/~dhbailey/mpdist/
// Addition: res = ds_add(a, b) => res = a + b
vec2 add (vec2 dsa, vec2 dsb) {
	vec2 dsc;
	float t1, t2, e;
	t1 = plus_frc(dsa.x, dsb.x);
	e = minus_frc(t1, dsa.x);
	t2 = plus_frc(plus_frc(plus_frc(minus_frc(dsb.x, e), minus_frc(dsa.x, minus_frc(t1, e))), dsa.y), dsb.y);
	dsc.x = plus_frc(t1, t2);
	dsc.y = minus_frc(t2, minus_frc(dsc.x, t1));
	return dsc;
}
// Subtract: res = ds_sub(a, b) => res = a - b
vec2 sub (vec2 dsa, vec2 dsb) {
	vec2 dsc;
	float e, t1, t2;
	t1 = minus_frc(dsa.x, dsb.x);
	e = minus_frc(t1, dsa.x);
	t2 = minus_frc(plus_frc(plus_frc(minus_frc(minus_frc(0.0, dsb.x), e), minus_frc(dsa.x, minus_frc(t1, e))), dsa.y), dsb.y);
	dsc.x = plus_frc(t1, t2);
	dsc.y = minus_frc(t2, minus_frc(dsc.x, t1));
	return dsc;
}
// Compare: res = -1 if a < b
//              = 0 if a == b
//              = 1 if a > b
float cmp(vec2 dsa, vec2 dsb) {
	if (dsa.x < dsb.x) {
		return -1.;
	}
	if (dsa.x > dsb.x) {
		return 1.;
	}
	if (dsa.y < dsb.y) {
		return -1.;
	}
	if (dsa.y > dsb.y) {
		return 1.;
	}
	return 0.;
}
// Multiply: res = ds_mul(a, b) => res = a * b
vec2 mul (vec2 dsa, vec2 dsb) {
	vec2 dsc;
	float c11, c21, c2, e, t1, t2;
	float a1, a2, b1, b2, cona, conb, split = 8193.;
	cona = times_frc(dsa.x, split);
	conb = times_frc(dsb.x, split);
	a1 = minus_frc(cona, minus_frc(cona, dsa.x));
	b1 = minus_frc(conb, minus_frc(conb, dsb.x));
	a2 = minus_frc(dsa.x, a1);
	b2 = minus_frc(dsb.x, b1);
	c11 = times_frc(dsa.x, dsb.x);
	c21 = plus_frc(times_frc(a2, b2), plus_frc(times_frc(a2, b1), plus_frc(times_frc(a1, b2), minus_frc(times_frc(a1, b1), c11))));
	c2 = plus_frc(times_frc(dsa.x, dsb.y), times_frc(dsa.y, dsb.x));
	t1 = plus_frc(c11, c2);
	e = minus_frc(t1, c11);
	t2 = plus_frc(plus_frc(times_frc(dsa.y, dsb.y), plus_frc(minus_frc(c2, e), minus_frc(c11, minus_frc(t1, e)))), c21);
	dsc.x = plus_frc(t1, t2);
	dsc.y = minus_frc(t2, minus_frc(dsc.x, t1));
	return dsc;
}
// create double-single number from float
vec2 set(float a) {
	return vec2(a, 0.0);
}
float rand(vec2 co) {
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec2 complexMul(vec2 a, vec2 b) {
	return vec2(a.x*b.x -  a.y*b.y,a.x*b.y + a.y * b.x);
}
// double complex multiplication
vec4 dcMul(vec4 a, vec4 b) {
	return vec4(sub(mul(a.xy,b.xy),mul(a.zw,b.zw)),add(mul(a.xy,b.zw),mul(a.zw,b.xy)));
}
// double complex addition
vec4 dcAdd(vec4 a, vec4 b) {
	return vec4(add(a.xy,b.xy),add(a.zw,b.zw));
}
// Length of double complex
vec2 dcLength(vec4 a) {
	return add(mul(a.xy,a.xy),mul(a.zw,a.zw));
}
// create double-complex from complex float
vec4 dcSet(vec2 a) {
	return vec4(a.x,0.,a.y,0.);
}
//create double-complex from complex double
vec4 dcSet(vec2 a, vec2 ad) {
	return vec4(a.x, ad.x,a.y,ad.y);
}
// Multiply double-complex with double
vec4 dcMul(vec4 a, vec2 b) {
	return vec4(mul(a.xy,b),mul(a.wz,b));
}


void main()
{
	vec4 uv = dcSet( gl_FragCoord.xy - resolution.xy * 0.5 );
	vec4 dcCenter = dcSet( center );

	vec4 c = dcAdd( dcMul( uv, set( zoom ) ), dcCenter );
	vec4 z = dcSet( vec2( 0.0 ) );
	vec4 dz = dcSet( vec2( 0.0 ) );
	bool escape = false;

	float dotZZ = 0.0;

	for ( int i = 0 ; i < maxIterations; i++ ) {
		//z' = 2 * z * z'+ 1
		//dz = 2.0 * vec2( z.x * dz.x - z.y * dz.y, z.x * dz.y + z.y * dz.x ) + vec2( 1.0, 0.0 );
		dz = dcAdd( dcMul( dcMul( z, dz ), set( 2.0 ) ), dcSet( vec2( 1.0, 0.0 ) ) );

		//mandelbrot function on z
		//z = c + complexSquare( z );
		z = dcAdd( c, dcMul( z, z ) );

		//escape radius 32^2
		//if ( dot( z, z ) > 1024.0 )
		//lowered to compensate for emulated double computation speed
		dotZZ = z.x * z.x + z.z * z.z; // extract high part
		if( dotZZ > 400.0 )
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

		float dotDZDZ = dz.x * dz.x + dz.z * dz.z; // extract high part

		float d = sqrt( dotZZ );
		d *= log( d );
		d /= sqrt( dotDZDZ );

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
