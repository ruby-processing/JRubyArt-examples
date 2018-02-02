#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;
out vec4 color;
uniform float time;

void main(void){

    vec4 uv = vec4(gl_FragCoord.xy, gl_FragCoord.xy) / resolution.xy;
    vec4 a = vec4(1.01, 1.11, 1.21, 1.31) * time * 0.2, p;

    float d = 0.5;

    for(float i = 0.; i < 20.; i++) {

        a += i * vec4(3.,4.,5.,6.) + vec4(1.3,2.5,3.3,4.1);
		p = fract(uv + sin(a)) - 0.5; // Wrapping the offset point.
        d = min(d, min(dot(p.xy, p.xy), dot(p.zw, p.zw))); // Take square root outside loop for efficiency.
    }

    // "dist>=0." and sqrt(Max)*4. = 1., so no clamping needed, in this case.
    d = sqrt(d)*4.;

    gl_FragColor = vec4(vec3(d*d*.5, d, pow(d, 0.66)), 1.0);
    color = gl_FragColor
}
