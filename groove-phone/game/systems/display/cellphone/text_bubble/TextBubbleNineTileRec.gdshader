shader_type canvas_item;

uniform bool flip_h = false;
uniform bool flip_v = false;

void fragment() {
	vec2 base_uv = UV;
	if (flip_h) { base_uv.x = 1.0 - base_uv.x; }
	if (flip_v) { base_uv.y = 1.0 - base_uv.y; }
	
	COLOR = texture(TEXTURE, base_uv);
}