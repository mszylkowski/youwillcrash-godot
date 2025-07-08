/*
 * Glitch Effect Shader by Yui Kinomoto @arlez80
 * MIT License
*/

shader_type canvas_item;
uniform float shake_power = 0.01;
uniform float shake_block_size = 100.;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.005;
uniform float shake_scale: hint_range(0.0, 1.0, 0.001) = 1.;
uniform sampler2D screen_texture : hint_screen_texture;

varying vec2 position;

float random(float seed) {
	seed = floor(seed * 50.) * .02;
	return fract(114.9512 * sin(dot(vec2(seed, seed), vec2(12.62, -35.5819))));
}

void fragment() {
	vec2 fixed_uv = SCREEN_UV;
	float block_size = max(shake_block_size * shake_scale, 0.001);
	float color_rate = shake_color_rate * shake_scale;
	fixed_uv.x += (random((trunc(random(position.y) * block_size) / block_size) + TIME) - 0.5) * shake_power * shake_scale;

	COLOR = textureLod(screen_texture, fixed_uv, 0.0);
	COLOR.r = textureLod(screen_texture, fixed_uv + vec2(color_rate, 0.), 0.).r;
	COLOR.b = textureLod(screen_texture, fixed_uv + vec2(-color_rate, 0.), 0.).b;
}

void vertex() {
	position = VERTEX * .001;
}
