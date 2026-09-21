shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D viewport : source_color;
uniform sampler2D noise;
uniform bool show_viewport = false;
uniform vec3 color : source_color;
uniform float min_alpha_value = 0.6;
uniform float max_alpha_value = 1.0;
uniform float time_scale = 0.25;


void fragment() {
	if (show_viewport) {
		vec4 albedo_texture = texture(viewport, SCREEN_UV);
		ALBEDO = albedo_texture.rgb;
	} else {
		vec4 tex = texture(noise, UV.xy);
		vec4 alpha_tex = texture(noise, UV.xy);
		
		ALBEDO = tex.xyz*color;
		ALPHA = clamp(texture(noise, alpha_tex.xy + TIME*time_scale).b, min_alpha_value, max_alpha_value);
	}
}