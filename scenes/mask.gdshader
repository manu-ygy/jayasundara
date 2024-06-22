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

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;
		
		if (pattern == 0) {
			offset = width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		} else if (pattern == 2) {
			offset = width;
		}
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a <= 0.0) == inside) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec4 sprite_color = texturePointSmooth(TEXTURE, UV, TEXTURE_PIXEL_SIZE);

	vec2 uv = UV;
	
	COLOR = sprite_color;
	
	if (all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))) {
		COLOR = sprite_color;
	} else {
		if ((COLOR.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
			COLOR.rgb += inside ? mix(COLOR.rgb, color.rgb, color.a) : color.rgb;
			COLOR.a += (1.0 - COLOR.a) * color.a;
		} else {
			COLOR.a = 0.0;
		}
	}
}