//noise function from iq: https://www.shadertoy.com/view/Msf3WH
shader_type canvas_item;

vec2 hash( vec2 p ) 
{
	p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec2 p )
{
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;

	vec2  i = floor( p + (p.x+p.y)*K1 );
    vec2  a = p - i + (i.x+i.y)*K2;
    float m = step(a.y,a.x); 
    vec2  o = vec2(m,1.0-m);
    vec2  b = a - o + K2;
	vec2  c = a - 1.0 + 2.0*K2;
    vec3  h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	vec3  n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
    return dot( n, vec3(70.0) );
}

const mat2 m2 = mat2(vec2(1.6,  1.2), vec2(-1.2,  1.6));

float fbm4(vec2 p) {
    float amp = 0.5;
    float h = 0.0;
    for (int i = 0; i < 4; i++) {
        float n = noise(p);
        h += amp * n;
        amp *= 0.5;
        p = m2 * p ;
    }
    
	return  0.5 + 0.5*h;
}

void fragment()
{
    // Normalized pixel coordinates (from 0 to 1)
	vec2 iResolution = 1.0/SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy/iResolution.xy;
	uv -= 0.5;
    uv.x *= iResolution.x/iResolution.y;
    vec2 mo = vec2(1.,1.)/iResolution.xy;
    vec3 sky = vec3(0.5, 0.7, 0.8);
    vec3 col = vec3(0.0);
    
    // speed
    float v = 0.001;

    // layer1
    vec3 cloudCol = vec3(1.0);
    uv += mo * 10.0;
   
    vec2 scale = uv * 2.0;
    vec2 turbulence = 0.008 * vec2(noise(vec2(uv.x * 10.0, uv.y *10.0)), noise(vec2(uv.x * 10.0, uv.y * 10.0)));
    scale += turbulence;
	float n1 = fbm4(vec2(scale.x - 20.0 * sin(TIME * v * 2.0), scale.y - 50.0 * sin(TIME * v)));
    col = mix( sky, cloudCol, smoothstep(0.5, 0.8, n1));
    
    //layer2
    scale = uv * 0.5;
    turbulence = 0.05 * vec2(noise(vec2(uv.x * 2.0, uv.y * 2.1)), noise(vec2(uv.x * 1.5, uv.y * 1.2)));
    scale += turbulence;
    float n2 = fbm4(scale + 20.0 * sin(TIME * v ));
    col =  mix( col, cloudCol, smoothstep(0.2, 0.9, n2));
    col = min(col, vec3(1.0));
    
    
    // Output to screen
    COLOR = vec4(col, 1.0);
}