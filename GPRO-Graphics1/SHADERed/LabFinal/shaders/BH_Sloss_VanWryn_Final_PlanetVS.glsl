#version 450 

// MAIN DUTY: processing vertex attributes
// 	3D point in space
// 	normal vector
// 	uv: texture coordinate
//OBJECT SPACE
layout (location = 0) in vec4 aPosition;
layout (location = 1) in vec3 aNormal;
//in vec4 aPosition
//layout (location = 2) in vec2 aTexcoord;
layout (location = 2) in vec4 aTexcoord;
//TEXTURE SPACE is it's own thing

//TRANSFORM UNIFOMS
uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjMat;
uniform mat4 uViewProjMat;

// EXAMPLE: Some uniform in a program.
//-------------------------------
// Some texture in the vertex shader:
uniform sampler2D uPlanetsList[3];
//-------------------------------
//time for motion
uniform float Time;
//-------------------------------
//thing for differentiation
uniform int Thing;
//-------------------------------

//VARYING 

out vec4 vTexcoord;

void main()
{
		
	//Position pipelinemat4 revolve amd orbit;
	float erthOrbitRad = 2.0;
	float munOrbitRad = 0.5;
	//orbit matrix for each object
	mat4 orbits[3];
	//scaling for each object.
	mat4 alterations[3];
	//rotation matrix to allow spinning motion
	mat4 revolve;
	revolve[0] = vec4(cos(Time), sin(Time), 0, 0);
	revolve[1] = vec4(-sin(Time), cos(Time), 0, 0);
	revolve[2] = vec4(0, 0, 1, 0);
	revolve[3] = vec4(0, 0, 0, 1);
	
	//sun alteration
	alterations[0][0] = vec4(0.5, 0.0, 0.0, 0.0);
	alterations[0][1] = vec4(0.0, 0.5, 0.0, 0.0);
	alterations[0][2] = vec4(0.0, 0.0, 0.5, 0.0);
	alterations[0][3] = vec4(0.0, 0.0, 0.0, 1.0);
	//earth alteration
	alterations[1][0] = vec4(0.2, 0.0, 0.0, 0.0);
	alterations[1][1] = vec4(0.0, 0.2, 0.0, 0.0);
	alterations[1][2] = vec4(0.0, 0.0, 0.2, 0.0);
	alterations[1][3] = vec4(0.0, 0.0, 0.0, 1.0);
	//moon alteration
	alterations[2][0] = vec4(0.1, 0.0, 0.0, 0.0);
	alterations[2][1] = vec4(0.0, 0.1, 0.0, 0.0);
	alterations[2][2] = vec4(0.0, 0.0, 0.1, 0.0);
	alterations[2][3] = vec4(0.0, 0.0, 0.0, 1.0);
	
	//sun orbit
	orbits[0][0] = vec4(1.0, 0.0, 0.0, 0.0);
	orbits[0][1] = vec4(0.0, 1.0, 0.0, 0.0);
	orbits[0][2] = vec4(0.0, 0.0, 1.0, 0.0);
	orbits[0][3] = vec4(0.0, 0.0, 0.0, 1.0);
	//Earth orbit
	orbits[1][0] = vec4(1, 0, 0, 0);
	orbits[1][1] = vec4(0, 1, 0, 0);
	orbits[1][2] = vec4(0, 0, 1, 0);
	orbits[1][3] = vec4(erthOrbitRad * sin(Time), erthOrbitRad * cos(Time), 0, 1);
	//Moon orbit
	orbits[2][0] = vec4(1, 0, 0, 0);
	orbits[2][1] = vec4(0, 1, 0, 0);
	orbits[2][2] = vec4(0, 0, 1, 0);
	orbits[2][3] = vec4(erthOrbitRad * sin(Time) + munOrbitRad * sin(3.0 * Time), erthOrbitRad * cos(Time) + munOrbitRad * cos(3.0 * Time), 0, 1);
	//ModelView Matrix with added revolve and orbit to complete the effect
	mat4 modlViewMat = uViewMat * uModelMat * orbits[Thing] * alterations[Thing] * revolve;		
	vec4 pos_view = modlViewMat * aPosition;
	vec4 pos_clip = uProjMat * pos_view;
	//seting gl_Position to clip space
	gl_Position = pos_clip;	
	
	
	//NORMAL PIPELINE
	mat3 normalMat = transpose(inverse(mat3(modlViewMat)));
	vec3 nrm_view = mat3(modlViewMat) * aNormal;
		
	// TEXCOORD PIPELINE (texture space is 2D)
	mat4 atlasMat = mat4(0.5, 0.0, 0.0, 0.0,
						 0.0, 0.5, 0.0, 0.0,
						 0.25, 0.0, 1.0, 0.0,
						 0.25, 0.0, 0.0, 1.0);
	vec4 uv_atlas = atlasMat * aTexcoord;
	
	//send changed texcoord to fragment shader	
	vTexcoord = uv_atlas;
	
}