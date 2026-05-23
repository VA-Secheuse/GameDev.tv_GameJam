  shader_type canvas_item;

uniform float outline_width : hint_range(0.0, 10.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    vec2 size = outline_width * TEXTURE_PIXEL_SIZE;
    
    float alpha = current_color.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV - vec2(size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV - vec2(0.0, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + size).a);
    alpha = max(alpha, texture(TEXTURE, UV - size).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, -size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, size.y)).a);
    
    vec4 outline = vec4(outline_color.rgb, outline_color.a * alpha);
    COLOR = mix(outline, current_color, current_color.a);
}