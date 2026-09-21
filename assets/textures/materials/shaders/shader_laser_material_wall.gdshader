shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float vertex_position_x_offset = .5;
uniform float vertex_position_z_offset = 5.0;
uniform float max_alpha_value = .7;
uniform float min_alpha_value = .1;
uniform float texture_speed = 0.25;
uniform float wave_speed = 1;
uniform vec3 color : source_color;
uniform sampler2D noise;
uniform sampler2D distorsion_noise;

varying vec2 vertex_position;

void vertex() {
	vertex_position = VERTEX.xz / 2.0 + 0.5;
	VERTEX.y += cos(VERTEX.x * TIME * wave_speed) * vertex_position_x_offset * sin(VERTEX.z * TIME * wave_speed) / vertex_position_z_offset;
}

void fragment() {
	vec4 noise_color = texture(distorsion_noise, UV.yx);
	
	ALBEDO = color;
	ALPHA = texture(noise, noise_color.xy+TIME*texture_speed).b * clamp(abs(sin(TIME))*max_alpha_value, max_alpha_value, min_alpha_value);
}
