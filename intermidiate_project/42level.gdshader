shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
		COLOR = vec4(vec3(TIME), sin(TIME)*cos(2.0*TIME))*texture(TEXTURE, UV)*texture(TEXTURE, UV)*texture(TEXTURE, UV)*texture(TEXTURE, UV)+texture(TEXTURE, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
