#version 450

layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec4 aTexcoord;

uniform mat4 uModelMat, uViewMat, uProjMat;
// Some texture in the vertex shader:
uniform sampler2D uTexture;
uniform sampler2D uTexture2;
//-------------------------------

out vec4 vNormal;
out vec2 vTexcoord;
out vec4 vPos;

void main()
{
	//setting gl_Position
	gl_Position = aPosition;
	//changeing texcoord and sending it to fragment shader
	vTexcoord = aPosition.xy * 0.5 + 0.5;
}