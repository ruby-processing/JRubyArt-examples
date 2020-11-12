// This implementation is based on GLSL code by ArKano22:
// http://www.gamedev.net/topic/590070-glsl-droste/
uniform int frameCount;
uniform sampler2D texture; // iChannel0 in Shadertoy
uniform vec2 resolution; // iResolution in Shadertoy
uniform int mode;

const float TWO_PI = 3.141592*2.0;
//ADJUSTABLE PARAMETERS:
const float Branches = 1.0;
const float scale = 0.4;
const float off = 0.6;
//Complex Math:
vec2 complexExp(in vec2 z){
	return vec2(exp(z.x)*cos(z.y),exp(z.x)*sin(z.y));
}
vec2 complexLog(in vec2 z){
	return vec2(log(length(z)), atan(z.y, z.x));
}
vec2 complexMult(in vec2 a,in vec2 b){
	return vec2(a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x);
}
float complexMag(in vec2 z){
	return length(z);
}
vec2 complexReciprocal(in vec2 a){ return vec2(a.x, -a.y) / dot(a, a); }
vec2 complexDiv(in vec2 a,in vec2 b){
	return complexMult(a, complexReciprocal(b));
}
vec2 complexPower(in vec2 a, in vec2 b){
	return complexExp( complexMult(b,complexLog(a))  );
}
//Misc Functions:
float nearestPower(in float a, in float base){
	return pow(base,  ceil(  log(abs(a))/log(base)  )-1.0 );
}
float map(float value, float istart, float istop, float ostart, float ostop) {
	   return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
}

void main( void ){

	//SHIFT AND SCALE COORDINATES
	vec2 uv=gl_FragCoord.xy/resolution.xy - off;

	//ESCHER GRID TRANSFORM:
	float factor = pow(1.0/scale,Branches);
	uv= complexPower(uv, complexDiv(vec2( log(factor) ,TWO_PI), vec2(0.0,TWO_PI) ) );

	//RECTANGULAR DROSTE EFFECT:
	float FT = float(frameCount % 100 / 100.0);
	FT = log(FT+1.)/log(2.);
	uv *= 1.0+FT*(scale-1.0);

  float npower = max(nearestPower(uv.x,scale),nearestPower(uv.y,scale));
	uv.x = map(uv.x,-npower,npower,-1.0,1.0);
	uv.y = map(uv.y,-npower,npower,-1.0,1.0);

	//UNDO SHIFT AND SCALE:
	gl_FragColor =  texture(texture,uv*off+vec2(off));
}
