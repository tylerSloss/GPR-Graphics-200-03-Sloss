#version 450  


layout (location = 0) out vec4 rtFragColor;
//out vec4 rtFragColor;

//VARYING 
//PER_VERTEX final color inbound
//in vec4 vColor;

//PER_Fragmet: pass requirements for final color
in vec4 vNormal1;
in vec4 vNormal2;

//in vec2 vTexcoord;
in vec4 vTexcoord;

// EXAMPLE: Some uniform in a program.
//-------------------------------
// Some texture in the vertex shader:
layout (binding = 0) uniform sampler2D uPlanets[4];
//-------------------------------
//thing for differentiation
uniform int Thing;
//-------------------------------


void main()
{
	//setting rtFragColor to the texture of the planet 
	rtFragColor = texture(uPlanets[Thing],2.0 * vTexcoord.xy);
}

