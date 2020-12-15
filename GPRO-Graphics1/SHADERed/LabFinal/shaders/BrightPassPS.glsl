#version 450

in vec2 vTexcoord;

layout (location = 0) out vec4 rtFragColor;

uniform sampler2D uTexture;
uniform sampler2D uTexture2;

void main()
{
	 //sets variable for background texture 
	 vec4 stars = texture(uTexture2,vTexcoord.xy);
	 //sets variable for planet texture
	 vec4 notStars = texture(uTexture,vTexcoord.xy);
	 //creates lumanince to brighten or darken spots of the texture 
	 float luminance = (0.2126 * notStars.x) + (0.7152 * notStars.y) + (0.0722 * notStars.z);
	 //multiplies lumanince to the nonBackground textures
	 notStars = notStars * luminance;
	 //mixes now luminated texture with background
	 rtFragColor = mix(stars,notStars,notStars.a);
}
