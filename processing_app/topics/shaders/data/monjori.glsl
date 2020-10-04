#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2  resolution;  // viewport resolution (in pixels)
uniform float  time;      // time in millis

void main( void )
{
    vec2 p = (2.0 * gl_FragCoord.xy / resolution.xy) - 1.0;
    float a = time * 40.0;

    // declare a bunch of variables.
    float d, g=1.0/40.0,h,i,r,q;
    vec2 ef = 200.0 * (p + 1.0);
    i = 200.0+sin(ef.x*g+a/150.0)*20.0;
    d = 200.0+cos(ef.y*g/2.0)*18.0+cos(ef.x*g)*7.0;
    r = length( vec2(i, d) - ef );
    q = ef.y/r;
    ef = vec2((r*cos(q))-a/2.0, (r*sin(q))-a/2.0);
    d = sin(ef.x*g)*176.0 + sin(ef.x*g)*164.0 + r;
    h = ((ef.y+d)+a/2.0)*g;
    i = cos(h+r*p.x/1.3)*(ef.x+ef.x+a) + cos(q*g*6.0)*(r+h/3.0);
    h = sin(ef.y*g)*144.0-sin(ef.x*g)*212.0*p.x;
    h = (h+(ef.y-ef.x)*q+sin(r-(a+h)/7.0)*10.0+i/4.0)*g;
    i += cos(h*2.3*sin(a/350.0-q)) * 184.0*sin(q-(r*4.3+a/12.0)*g) + sin(r*g+h)*184.0;
    // Split into 4 segments
    i  = mod(i/5.6,256.0)/64.0;
    if (i <  0.0) i += 4.0;
    if (i >= 2.0) i  = 4.0-i;
    d  = r/350.0;
    d += sin(d*d*8.0)*0.52;
    ef.y = (sin(a*g)+1.0)/2.0;
    gl_FragColor = vec4(vec3(ef.y*i/1.6,i/2.0+d/13.0,i)*d*p.x+vec3(i/1.3+d/8.0,i/2.0+d/18.0,i)*d*(1.0-p.x),1.0);
}
