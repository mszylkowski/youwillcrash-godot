shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable, filter_nearest;

varying vec2 position;

group_uniforms water;
uniform sampler2D waterNoise : repeat_enable, filter_linear;
uniform vec4 waterColor : source_color = vec4(0.117, 0.27, 0.58, 1);
uniform float colorCorrection : hint_range(0.0, 1.0, 0.01) = 0.35;
uniform float distortionStrength : hint_range(0.0, 1., 0.001) = 1;
uniform float distortionScale : hint_range(0.0, 1.0, 0.01) = 1.5;
uniform float distortionSpeed : hint_range(0.0, 1.0, 0.01) = .1;

void fragment() {
	vec2 distortion = (texture(waterNoise, position * distortionScale + TIME * distortionSpeed).rg * distortionStrength * 2. - distortionStrength) * .01;
	vec4 reflection = (texture(waterNoise, position * distortionScale * 7. + vec2(TIME * distortionSpeed * .2, TIME * distortionSpeed) * 4. + distortion) + texture(waterNoise, -position * distortionScale * 7. + vec2(TIME * distortionSpeed * 1.2, TIME * distortionSpeed) * 4. + distortion)) * .5;
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV + distortion);
	COLOR = mix(color, waterColor, colorCorrection) + pow(reflection.x, 4.);

	if (position.y + .44 < sin(position.x * 10. + TIME) * .03) {
		COLOR.a = 0.;
	}
}

void vertex() {
	position = VERTEX * .001;
}
