shader_type canvas_item;

uniform vec4 color : source_color;
uniform float flashState : hint_range(0,1) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 icol = texture(TEXTURE, UV);
		
	COLOR = mix(icol, color, flashState);
	COLOR.a *= icol.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
