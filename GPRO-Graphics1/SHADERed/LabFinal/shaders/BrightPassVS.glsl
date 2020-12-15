#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;
// Some texture in the vertex shader:
uniform sampler2D uTexture;
uniform sampler2D uTexture2;
//-------------------------------


out vec2 vTexcoord;

void main()
{
	//setting position
	gl_Position = aPosition;
	//making adjustments to texcoord
	vTexcoord = aPosition.xy * 0.5 + 0.5;
}