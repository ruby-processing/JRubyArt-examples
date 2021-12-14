#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// From a shadertoy sketch by Victor Shepardson
// https://www.shadertoy.com/view/ltfXzj

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)

const float pi = 3.14159;

float sigmoid(float x){
 	return x/(1.+abs(x));
}

float iter(vec2 p, vec4 a, vec4 wt, vec4 ws, float t, float m, float stereo){
    float wp = .2;
    vec4 phase = vec4(mod(t, wp), mod(t+wp*.25, wp), mod(t+wp*.5, wp), mod(t+wp*.75, wp))/wp;
    float zoom = 1./(1.+.5*(p.x*p.x+p.y*p.y));
    vec4 scale = zoom*pow(vec4(2.), -4.*phase);
    vec4 ms = .5-.5*cos(2.*pi*phase);
    vec4 pan = stereo/scale*(1.-phase)*(1.-phase);
    vec4 v = ms*sin( wt*(t+m) + (m+ws*scale)*((p.x+pan) * cos((t+m)*a) + p.y * sin((t+m)*a)));
    return sigmoid(v.x+v.y+v.z+v.w+m);
}

vec3 scene(float gt, vec2 uv, vec4 a0, vec4 wt0, vec4 ws0, float blur){
    //time modulation
    float tm = mod(.0411*gt, 1.);
    tm = sin(2.*pi*tm*tm);
    float t = (.04*gt + .05*tm);

    float stereo = 1.*(sigmoid(2.*(sin(1.325*t*cos(.5*t))+sin(-.7*t*sin(.77*t)))));//+sin(-17.*t)+sin(10.*t))));
    //t = 0.;
    //also apply spatial offset
    uv+= .5*sin(.33*t)*vec2(cos(t), sin(t));

    //wildly iterate and divide
    float p0 = iter(uv, a0, wt0, ws0, t, 0., stereo);

   	float p1 = iter(uv, a0, wt0, ws0, t, p0, stereo);

    float p2 = sigmoid(p0/(p1+blur));

    float p3 = iter(uv, a0, wt0, ws0, t, p2, stereo);

    float p4 = sigmoid(p3/(p2+blur));

    float p5 = iter(uv, a0, wt0, ws0, t, p4, stereo);

    float p6 = sigmoid(p4/(p5+blur));

    float p7 = iter(uv, a0, wt0, ws0, t, p6, stereo);

    float p8 = sigmoid(p4/(p2+blur));

    float p9 = sigmoid(p8/(p7+blur));

    float p10 = iter(uv, a0, wt0, ws0, t, p8, stereo);

    float p11 = iter(uv, a0, wt0, ws0, t, p9, stereo);

    float p12 = sigmoid(p11/(p10+blur));

    float p13 = iter(uv, a0, wt0, ws0, t, p12, stereo);

    //colors
    vec3 accent_color = vec3(1.,0.2,0.);//vec3(0.99,0.5,0.2);
    /*float r = sigmoid(-1.+2.*p0+p1-max(1.*p3,0.)+p5+p7+p10+p11+p13);
    float g = sigmoid(-1.+2.*p0-max(1.*p1,0.)-max(2.*p3,0.)-max(2.*p5,0.)+p7+p10+p11+p13);
    float b = sigmoid(0.+1.5*p0+p1+p3+-max(2.*p5,0.)+p7+p10+p11+p13);
    */
    float r = sigmoid(p0+p1+p5+p7+p10+p11+p13);
    float g = sigmoid(p0-p1+p3+p7+p10+p11);
    float b = sigmoid(p0+p1+p3+p5+p11+p13);


    vec3 c = max(vec3(0.), .4+.6*vec3(r,g,b));

    float eps = .4;
    float canary = min(abs(p1), abs(p2));
    canary = min(canary, abs(p5));
    //canary = min(canary, abs(p6));
    canary = min(canary, abs(p7));
    canary = min(canary, abs(p10));
    float m = max(0.,eps-canary)/eps;
    m = sigmoid((m-.5)*700./(1.+10.*blur))*.5+.5;
    //m = m*m*m*m*m*m*m*m*m*m;
    vec3 m3 = m*(1.-accent_color);
    c *= .8*(1.-m3)+.3;//mix(c, vec3(0.), m);

    return c;
}

void main( void )
{
    float s = min(iResolution.x, iResolution.y);
   	vec2 uv = (2.*gl_FragCoord.xy - vec2(iResolution.xy)) / s;

    float blur = .5*(uv.x*uv.x+uv.y*uv.y);

    //angular, spatial and temporal frequencies
    vec4 a0 = pi*vec4(.1, -.11, .111, -.1111);
    vec4 wt0 = 2.*pi*vec4(.3);//.3333, .333, .33, .3);
    vec4 ws0 = 2.5*vec4(11., 13., 11., 5.);

    //aa and motion blur
    float mb = 1.;
    float t = 1100.+iTime;
    vec3 c = scene(t, uv, a0, wt0, ws0, blur)
        + scene(t-mb*.00185, uv+(1.+blur)*vec2(.66/s, 0.), a0, wt0, ws0, blur)
        + scene(t-mb*.00370, uv+(1.+blur)*vec2(-.66/s, 0.), a0, wt0, ws0, blur)
        + scene(t-mb*.00555, uv+(1.+blur)*vec2(0., .66/s), a0, wt0, ws0, blur)
        + scene(t-mb*.00741, uv+(1.+blur)*vec2(0., -.66/s), a0, wt0, ws0, blur)
        + scene(t-mb*.00926, uv+(1.+blur)*vec2(.5/s, .5/s), a0, wt0, ws0, blur)
        + scene(t-mb*.01111, uv+(1.+blur)*vec2(-.5/s, .5/s), a0, wt0, ws0, blur)
        + scene(t-mb*.01296, uv+(1.+blur)*vec2(-.5/s, -.5/s), a0, wt0, ws0, blur)
        + scene(t-mb*.01481, uv+(1.+blur)*vec2(.5/s, -.5/s), a0, wt0, ws0, blur)

        ;
    c/=9.;

    gl_FragColor = vec4(c,1.0);
}
