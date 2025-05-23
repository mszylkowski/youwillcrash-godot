shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 shadow_offset = vec2(10.);
uniform vec4 shadow_color : source_color = vec4(0, 0, 0, .5);

void fragment() {
	vec4 original_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 screen_pixel_size = 1.0 / vec2(textureSize(screen_texture, 0));
	vec2 uv_offset = shadow_offset / vec2(textureSize(screen_texture, 0));
	float caster_alpha = textureLod(screen_texture, SCREEN_UV - uv_offset, 0.0).a;
	vec4 shadow_layer = vec4(shadow_color.rgb, shadow_color.a * caster_alpha);
	shadow_layer.rgb *= shadow_layer.a;

	if (original_color.a > 0.0) {
	    original_color.rgb /= original_color.a;
	} else {
		original_color.rgb = vec3(0);
	}

	COLOR = original_color + shadow_layer * (1.0 - original_color.a);
}