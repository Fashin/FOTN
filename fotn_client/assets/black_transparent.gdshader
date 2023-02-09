shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.a = 0.5;
    COLOR = color;
}