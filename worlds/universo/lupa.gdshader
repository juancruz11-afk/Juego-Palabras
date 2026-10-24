shader_type canvas_item;

uniform vec2 centro = vec2(576.0, 324.0);
uniform float radio = 150.0;
uniform float suavizado = 4.0;
uniform float opacidad = 1.0;

varying vec2 pos;

void vertex() {
	pos = VERTEX;
}

void fragment() {
	float d = distance(pos, centro);
	float a = smoothstep(radio - suavizado, radio, d);
	COLOR = vec4(0.0, 0.0, 0.05, a * opacidad);
}
