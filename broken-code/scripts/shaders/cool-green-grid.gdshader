shader_type canvas_item;

uniform vec2 grid_size = vec2(48.0, 48.0); // distance between lines
uniform float line_thickness = 0.1; // line thickness
uniform vec4 grid_color : source_color = vec4(0.0, 1.0, 0.0, 0.5); // green line color
uniform vec2 offset = vec2(0.0, 0.0); // offset for scrolling
uniform vec2 screen_size = vec2(1152.0, 648.0); // yeah
uniform float glow_radius = 5.0; // how far the glow spreads
uniform float glow_strength = 0.2; // intensity multiplier

void fragment() {
	vec2 uv_pixels = UV * screen_size + offset;

	// compute distance to nearest grid line in x and y
	vec2 grid = abs(fract(uv_pixels / grid_size) - 0.5) / fwidth(uv_pixels / grid_size);
	float line_dist = min(grid.x, grid.y);

	// main line
	float line_alpha = 1.0 - smoothstep(line_thickness, line_thickness + 1.0, line_dist);

	// glow bleed: soft exponential falloff from the line
	float glow_alpha = exp(-line_dist * line_dist / (glow_radius * glow_radius)) * glow_strength;

	// edge vignette
	vec2 centered = abs(UV - 0.5) * 2.0;
	float dist = max(centered.x, centered.y);
	float vignette = smoothstep(0.2, 0.9, dist);

	COLOR = vec4(grid_color.rgb, (line_alpha + glow_alpha) * (1.0 - vignette));
}
