shader_type spatial;

const float PI = 3.14159265;

uniform float _time;
uniform vec4 wave_1;
uniform vec4 wave_2;
uniform vec4 wave_3;


vec3 gerstner_wave(vec4 wavevars, vec3 vert, vec3 tangent, vec3 binormal){
	vec3 p = vert;
	vec2 _direction = wavevars.xy;
	float _wavelength = wavevars.a;
	float _steepness = wavevars.z;
	
	vec2 d = normalize(_direction);
	float dp = dot(d, p.xz);
	float k = 2.0 * PI / _wavelength;
	float c = sqrt(9.8 / k);
	float f = k * (dp - c * TIME);
	
	float _amplitude = _steepness / k;
	
	tangent += vec3(
		1.0 - d.x * d.x * (_steepness * sin(f)),
		d.x * (_steepness *cos(f)),
		-d.x * d.y * (_steepness * sin(f))
	);
	binormal += vec3(
		-d.x * d.y * (_steepness * sin(f)),
		d.y * (_steepness * cos(f)),
		1.0 - d.y * d.y * (_steepness * sin(f))
	);

	
	return vec3(
		d.x * (_amplitude * cos(f)),
		_amplitude * sin(f),
		d.y * (_amplitude * cos(f))
	);
}


void vertex(){
	vec3 tangent;
	vec3 binormal;
	vec3 worldVert = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 p = worldVert;
	
	p += gerstner_wave(wave_1, worldVert, tangent, binormal);
	p += gerstner_wave(wave_2, worldVert, tangent, binormal);
	p += gerstner_wave(wave_3, worldVert, tangent, binormal);
	vec3 normal = normalize(cross(binormal, tangent));
	VERTEX = p;
	NORMAL = normal;
}
