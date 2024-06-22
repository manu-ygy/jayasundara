shader_type canvas_item;

// Allows you to control the output color in the Shader Params in the Inspector.
uniform vec4 silhouette_color : source_color;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear;
uniform vec4 outline_color : source_color;

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
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;

	if (screen_color.r < 10.0){
		COLOR.rgb = outline_color.rgb;
		
		// We convert the pixel width we want for our outline in decimal texel size.
		vec2 size = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
		
		// We sample and offset the texture 8 times to draw an outline.
		float alpha = tex_color.a;
		alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
		alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		
		// If the summed alpha is too high, it means we're over the original texture
		// and we don't want to draw this pixel; it's not part of the outline.
		if (alpha >= 9.0) {
			alpha = 0.0;
		}
		
		// We then override the texture's color with the calculated outline.
		COLOR = vec4(outline_color.rgb, min(alpha, 1.0) * tex_color.a);
	}
}
