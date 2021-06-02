#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

/** ----------------------
After a sketch on shadertoy https://www.shadertoy.com/user/atomek
**/

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click

void main()
{
	// Hold the mouse and drag to adjust

	float ratio = iResolution.y / iResolution.x;
	float divider = float(iMouse.x / iResolution.x * 10.0) + 1.0;
	float intensity = float(iMouse.y / iResolution.y * 10.0) + 1.0;

	float coordX = gl_FragCoord.x / iResolution.x;
	float coordY = gl_FragCoord.y / iResolution.x;

	float ball1x = sin(iTime * 2.1) * 0.5 + 0.5;
	float ball1y = cos(iTime * 1.0) * 0.5 + 0.5;
	float ball1z = sin(iTime * 2.0) * 0.1 + 0.2;

	float ball2x = sin(iTime * 1.0) * 0.5 + 0.5;
	float ball2y = cos(iTime * 1.8) * 0.5 + 0.5;
	float ball2z = cos(iTime * 2.0) * 0.1 + 0.2;

	float ball3x = sin(iTime * 0.7) * 0.5 + 0.5;
	float ball3y = cos(iTime * 1.5) * 0.5 + 0.5;
	float ball3z = cos(iTime * 1.0) * 0.1 + 0.2;

	vec3 ball1 = vec3(ball1x, ball1y * ratio, ball1z);
	vec3 ball2 = vec3(ball2x, ball2y * ratio, ball2z);
	vec3 ball3 = vec3(ball3x, ball3y * ratio, ball3z);

	float sum = 0.0;
	sum += ball1.z / distance(ball1.xy, vec2(coordX, coordY));
	sum += ball2.z / distance(ball2.xy, vec2(coordX, coordY));
	sum += ball3.z / distance(ball3.xy, vec2(coordX, coordY));

    sum = pow(sum / intensity, divider);

	gl_FragColor = vec4(sum * 0.2, sum * 0.2, sum * 0.4, 1.0);
}
