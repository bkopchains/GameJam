
shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	float brightness = (pixelColor.r + pixelColor.b + pixelColor.g) / 3.0;
	vec4 gradientColor = texture(gradient, vec2(brightness));
	COLOR = vec4(gradientColor.r, gradientColor.g, gradientColor.b, pixelColor.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
