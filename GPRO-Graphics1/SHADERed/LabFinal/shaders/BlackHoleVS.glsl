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
uniform mat4 uInvModMat;
uniform mat4 uViewMat;
uniform mat4 uProjMat;
uniform mat4 uViewProjMat;

// EXAMPLE: Some uniform in a program.
//-------------------------------
// Some texture in the vertex shader:
uniform sampler2D uPlanetsList[4];
//-------------------------------
//time for motion
uniform float Time;
//-------------------------------
//thing for differentiation
uniform int Thing;
//-------------------------------


//VARYING 

//PER_VERTEX: pass final Color
//out vec4 vColor;

//PER_Fragmet: pass requirements for final color
out vec4 vNormal1;
out vec4 vNormal2;

//out vec2 vTexcoord;
out vec4 vTexcoord;

out vec4 vPos;

void main()
{
	//Position pipelinemat4 revolve and orbit;
	float erthOrbitRad = 2.0;
	float munOrbitRad = 0.5;
	//orbit matrix for each object
	mat4 orbits[4];
	//scaling for each object.
	mat4 alterations[4];
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
	//black hole alteration
	alterations[3][0] = vec4(0.1, 0.0, 0.0, 0.0);
	alterations[3][1] = vec4(0.0, 0.1, 0.0, 0.0);
	alterations[3][2] = vec4(0.0, 0.0, 0.1, 0.0);
	alterations[3][3] = vec4(0.0, 0.0, 0.0, 1.0);
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
	//black hole orbit
	orbits[3][0] = vec4(1.0, 0.0, 0.0, 0.0);
	orbits[3][1] = vec4(0.0, 1.0, 0.0, 0.0);
	orbits[3][2] = vec4(0.0, 0.0, 1.0, 0.0);
	orbits[3][3] = vec4(0.0, 0.0, 0.0, 1.0);
	//black hole model matrix to use for positioning of camera
	mat4 bhModlMat;
	bhModlMat[0] = vec4(1.0, 0.0, 0.0, 0.0);
	bhModlMat[1] = vec4(0.0, 1.0, 0.0, 0.0);
	bhModlMat[2] = vec4(0.0, 0.0, 1.0, 0.0);
	bhModlMat[3] = vec4(0.0, 1.039, 2.626, 1.0);
	//modified projection matrix
	mat4 bhProjMat;
	bhProjMat[0] = vec4(-0.591, 0.0, 0.0, 0.0);
	bhProjMat[1] = vec4(0.0, 0.414, 0.0, 0.0);
	bhProjMat[2] = vec4(0.0, 0.0, -1.0, -1.0);
	bhProjMat[3] = vec4(0.0, 0.0, -1.0, 1.0);
	//modified view matrix incorperatin new view matrix with alterations and orbits	
	mat4 modlViewMat = transpose(inverse(bhModlMat))/* uViewMat*/ * uModelMat * orbits[Thing] * alterations[Thing] * revolve;		
	vec4 pos_view = modlViewMat * aPosition;
	vec4 pos_clip = bhProjMat * pos_view;
	//setting gl_Position to clip space 
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
	
	
	//PER_FRAGMENT: OUTPUT anything fragment shader needs to calc final color
	vNormal1 = vec4(aNormal,0.0);
	vNormal2 = vec4(nrm_view,0.0);		
	
	//vTexcoord = aTexcoord;	
	vTexcoord = uv_atlas;
	//gl_Position = /*uProjMat * modlViewMat * */ aTexcoord;
		

}