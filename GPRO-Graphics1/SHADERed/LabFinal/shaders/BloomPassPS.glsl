#version 450

in vec2 vTexcoord;
in vec2 iResolution;

layout (location = 0) out vec4 rtFragColor;

uniform sampler2D uTexture;
uniform sampler2D uTexture2;

void main()
{
	//calc for single pixel
    float xJump = 1.0 / iResolution.x; // inverse resolution x
    float yJump = 1.0 / iResolution.y; // inverse resolution y
	//for 3x3
    float weights[3] = float[3](1.0,2.0,4.0); // 3x3 kernal
    float weights2[6] = float[6](1.0,4.0,7.0,16.0,26.0,41.0); // 5x5 kernal
	vec4 space = texture(uTexture2,vTexcoord.xy);
	vec4 deepSpace = texture(uTexture,vTexcoord.xy);
	//float luminance = (0.2126 * deepSpace.x) + (0.7152 * deepSpace.y) + (0.0722 * deepSpace.z);
	
	                                 
deepSpace = (
    // Row 1 of 5x5 kernal
        texture(uTexture, vec2(vTexcoord.x - 2.0*xJump, vTexcoord.y + 2.0*yJump)) * weights2[0] +
		texture(uTexture, vec2(vTexcoord.x - xJump, vTexcoord.y + 2.0*yJump)) * weights2[1] +                                 
        texture(uTexture, vec2(vTexcoord.x, vTexcoord.y + 2.0*yJump)) * weights2[2] +
        texture(uTexture, vec2(vTexcoord.x + xJump, vTexcoord.y + 2.0*yJump)) * weights2[1] +
        texture(uTexture, vec2(vTexcoord.x + 2.0*xJump, vTexcoord.y + 2.0*yJump)) * weights2[0] +
    
    // Row 2 of 5x5
        texture(uTexture, vec2(vTexcoord.x - 2.0*xJump, vTexcoord.y + yJump)) * weights2[1] +
		texture(uTexture, vec2(vTexcoord.x - xJump, vTexcoord.y + yJump)) * weights2[3] +                                 
        texture(uTexture, vec2(vTexcoord.x, vTexcoord.y + yJump)) * weights2[4] +
        texture(uTexture, vec2(vTexcoord.x + xJump, vTexcoord.y + yJump)) * weights2[3] +
        texture(uTexture, vec2(vTexcoord.x + 2.0*xJump, vTexcoord.y + yJump)) * weights2[1] +
     
    // Row 3 of 5x5
        texture(uTexture, vec2(vTexcoord.x - 2.0*xJump, vTexcoord.y)) * weights2[2] +
		texture(uTexture, vec2(vTexcoord.x - xJump, vTexcoord.y)) * weights2[4] +                                 
        texture(uTexture, vec2(vTexcoord.x, vTexcoord.y)) * weights2[5] +
        texture(uTexture, vec2(vTexcoord.x + xJump, vTexcoord.y)) * weights2[4] +
        texture(uTexture, vec2(vTexcoord.x + 2.0*xJump, vTexcoord.y)) * weights2[2] +
    
    // Row 4 of 5x5    
        texture(uTexture, vec2(vTexcoord.x - 2.0*xJump, vTexcoord.y - yJump)) * weights2[1] +
		texture(uTexture, vec2(vTexcoord.x - xJump, vTexcoord.y - yJump)) * weights2[3] +                                 
        texture(uTexture, vec2(vTexcoord.x, vTexcoord.y - yJump)) * weights2[4] +
        texture(uTexture, vec2(vTexcoord.x + xJump, vTexcoord.y - yJump)) * weights2[3] +
        texture(uTexture, vec2(vTexcoord.x + 2.0*xJump, vTexcoord.y - yJump)) * weights2[1] +
     
    // Row 5 of 5x5
        texture(uTexture, vec2(vTexcoord.x - 2.0*xJump, vTexcoord.y - 2.0*yJump)) * weights2[0] +
		texture(uTexture, vec2(vTexcoord.x - xJump, vTexcoord.y - 2.0*yJump)) * weights2[1] +                                 
        texture(uTexture, vec2(vTexcoord.x, vTexcoord.y - 2.0*yJump)) * weights2[2] +
        texture(uTexture, vec2(vTexcoord.x + xJump, vTexcoord.y - 2.0*yJump)) * weights2[1] +
        texture(uTexture, vec2(vTexcoord.x + 2.0*xJump, vTexcoord.y -2.0*yJump)) * weights2[0] 
        ) / 273.0;
	
	//deepSpace = deepSpace * luminance ;
	rtFragColor = mix(deepSpace,space,space.a);
}
