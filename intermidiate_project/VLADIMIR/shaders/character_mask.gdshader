shader_type canvas_item;

uniform vec4 modulate_color : source_color;

void vertex() {
	COLOR = modulate_color;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
