shader_type canvas_item;
instance uniform float hit = 0.0;
uniform sampler2D noise: repeat_enable;
uniform vec4 modulate_color:  source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {



	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
