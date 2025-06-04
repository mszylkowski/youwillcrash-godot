shader_type canvas_item;
render_mode world_vertex_coords;

uniform vec4 border_color: source_color = vec4(0);
uniform vec4 center_color: source_color = vec4(0);
uniform float border_radius = .05;
uniform vec2 frame_size = vec2(400, 400);

varying vec2 position;

bool in_rect(vec2 size, float radius, vec2 uv) {
	vec2 center_dist = abs(uv);
	//return center_dist.x < frame_size.x && center_dist.y < frame_size.y;
	vec2 radius_center = size - radius;
	float corner_dist = distance(center_dist, radius_center);
	vec2 edges_dist = center_dist - radius_center;
	return corner_dist < radius || (edges_dist.x < 0. && edges_dist.y < radius) || (edges_dist.y < 0. && edges_dist.x < radius);
}

void vertex() {
	position = VERTEX.xy;
}

void fragment() {
	if(in_rect(frame_size, border_radius, position)) {
		COLOR = center_color;
	} else {
		COLOR = border_color;
	}
}
