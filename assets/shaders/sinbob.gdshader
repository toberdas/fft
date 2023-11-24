shader_type canvas_item;

uniform float amount = 12.0;
uniform float uvAmount = 1.0;

void vertex(){
	float ySin = sin(TIME) * (1.0 + (UV.x * uvAmount)) * amount;
	VERTEX.y += ySin;
}