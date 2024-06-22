shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 silhouette_color: source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform bool inside = false;
uniform bool add_margins = true; // only useful when inside is false

vec4 texturePointSmooth(sampler2D smp, vec2 uv, vec2 pixel_size)
{
	vec2 ddx = dFdx(uv);
	vec2 ddy = dFdy(uv);
	vec2 lxy = sqrt(ddx * ddx + ddy * ddy);
	
	vec2 uv_pixels = uv / pixel_size;
	
	vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
	vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;
	
	uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy + vec2(0.5f), 0.0f, 1.0f);
	
	uv = uv_pixels_floor * pixel_size;
	
	return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy);
}

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec4 sprite_color = texturePointSmooth(TEXTURE, UV, TEXTURE_PIXEL_SIZE);

	vec2 uv = UV;
	
	if (all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))) {
		COLOR.a = 0.0;
	} else {
		COLOR = sprite_color;
	}
}