shader_type canvas_item;

uniform float greyscaleIntensity = 1.0;
uniform float greyscalePerentage = 1.0;

void fragment() {
	float greyscale = (COLOR.r + COLOR.g + COLOR.b) / 3.0 * greyscaleIntensity;
	if (UV.x > greyscalePerentage)
		COLOR = vec4(greyscale, greyscale, greyscale, COLOR.a);
}
