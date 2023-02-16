shader_type canvas_item;

uniform sampler2D gradient : hint_black;
uniform float mix_amount : hint_range(0.0, 1.0) = 1.0;

void fragment(){
	vec4 input_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	float brightness = (input_color.r + input_color.g + input_color.b) / 3.0;
	vec4 gradient_color = texture(gradient, vec2(brightness));
	COLOR = mix(input_color, gradient_color, mix_amount);
}