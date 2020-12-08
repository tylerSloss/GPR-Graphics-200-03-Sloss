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


//renamed dotproduct function, overloaded for vec2 - vec4
float lenSq(in vec2 x)
{
 	return dot(x,x); 
}
float lenSq(in vec3 x)
{
 	return dot(x,x);
}
float lenSq(in vec4 x)
{
 	return dot(x,x);
}

// asPoint: promote a 3D vector into a 4D vector representing a point (w=1)
//    point: input 3D vector
vec4 asPoint(in vec3 point)
{
    return vec4(point, 1.0);
}

// asOffset: promote a 3D vector into a 4D vector representing an offset (w=0)
//    offset: input 3D vector
vec4 asOffset(in vec3 offset)
{
    return vec4(offset, 0.0);
}

//light structure and initulization 
struct pointLight{
	vec4 center;
    vec3 color;
    float intensity;
};
    
void initLight(out pointLight lite, in vec3 cent, in vec3 col, in float intense)
{
    lite.center = asPoint(cent);
    lite.color = col;
    lite.intensity = intense;
}

float calcAttenuation(pointLight lite, vec3 normal, vec3 position)
{
    float d = lenSq(lite.center.xyz - position);
    return 1.0/(1.0 + sqrt(d)/lite.intensity + d/(lite.intensity * lite.intensity));
}

vec3 calcDiffuseCoefficient(vec3 normal, vec3 position, vec3 liteCent)
{
    return (normal * normalize(liteCent - position));
}

float calcSpecularIntensity(pointLight lite, vec3 normal, vec3 position, vec3 rayDirection)
{
    //speccoeff
    float scale = lenSq(rayDirection);
    float Ks = dot(reflect(normalize(lite.center.xyz - position), normal), vec3(rayDirection.x / scale, rayDirection.y / scale, rayDirection.z / scale));
    //highlight exponent
    float eh = 2.0;
    eh = eh * eh; //4
    //eh = eh * eh; //8
    //eh = eh * eh; //16
    //eh = eh * eh; //32
    //eh = eh * eh; //64
    
    return pow(Ks, eh);
}

//Phong Reflectance
vec3 phongReflectance(in pointLight lite, vec3 normal, vec3 position, vec3 color, vec3 rayDirection)
{
    vec3 Id = calcDiffuseCoefficient(normal, position, lite.center.xyz) * calcAttenuation(lite, normal, position);
    float Is = calcSpecularIntensity(lite, normal, position, rayDirection);
    vec3 Cs = vec3(0.9, 0.4, 0.3);
    
    return (Id * color + Is * Cs) * lite.color;
}

vec3 lightCombo(in pointLight lite1,in pointLight lite2,in pointLight lite3,in vec3 normal,in vec3 position,in vec3 color,in vec3 rayDirection)
{
	float Ia = 0.2;
    vec3 Ca = vec3(0.7, 0.7, 0.7);
    vec3 combo = phongReflectance(lite1,normal,position,color,rayDirection);
    combo += phongReflectance(lite2,normal,position,color,rayDirection);
    combo += phongReflectance(lite3,normal,position,color,rayDirection);
    return (Ia * Ca) + combo;
}

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
	
	
	//REQUIRED: write to this variable:
	//Problem: gl_Position is in "clip_space"
	//problem: aPosition is in "object_space"	
	//gl_Position = aPosition;
	
	//postition in world space (not yet correct)
	//vec4 pos_world = uModelMat * aPosition;
	//gl_Position = pos_world;
	
	//positon in camera space
	//vec4 pos_view = uViewMat * pos_world;
	//vec4 pos_view = uViewMat * uModelMat * aPosition;
	//gl_Position = pos_view;
	
	//Position pipelinemat4 revolve amd orbit;
	float erthOrbitRad = 2.0;
	float munOrbitRad = 0.5;
	mat4 revolve;
	revolve[0] = vec4(cos(Time), sin(Time), 0, 0);
	revolve[1] = vec4(-sin(Time), cos(Time), 0, 0);
	revolve[2] = vec4(0, 0, 1, 0);
	revolve[3] = vec4(0, 0, 0, 1);
	mat4 orbit;
	orbit[0] = vec4(1, 0, 0, 0);
	orbit[1] = vec4(0, 1, 0, 0);
	orbit[2] = vec4(0, 0, 1, 0);
	orbit[3] = vec4(erthOrbitRad * sin(Time), erthOrbitRad * cos(Time), 0, 1);
	mat4 orbit2;
	orbit2[0] = vec4(1, 0, 0, 0);
	orbit2[1] = vec4(0, 1, 0, 0);
	orbit2[2] = vec4(0, 0, 1, 0);
	orbit2[3] = vec4(erthOrbitRad * sin(Time) + munOrbitRad * sin(3.0 * Time), erthOrbitRad * cos(Time) + munOrbitRad * cos(3.0 * Time), 0, 1);
	mat4 alteration;
	alteration[0] = vec4(1.0, 0.0, 0.0, 0.0);
	alteration[1] = vec4(0.0, 1.0, 0.0, 0.0);
	alteration[2] = vec4(0.0, 0.0, 1.0, 0.0);
	alteration[3] = vec4(0.0, 0.0, 0.0, 1.0);
	if(Thing == 1.0)
	{
		alteration = orbit;
	}
	else if (Thing == 2.0)
	{
		alteration = orbit2;
	}	
	mat4 modlViewMat = uViewMat * uModelMat * alteration * revolve;		
	vec4 pos_view = modlViewMat * aPosition;
	vec4 pos_clip = uProjMat * pos_view;
	gl_Position = pos_clip;
	vPos = aPosition;
	
	
	
	//NORMAL PIPELINE
	mat3 normalMat = transpose(inverse(mat3(modlViewMat)));
	vec3 nrm_view = mat3(modlViewMat) * aNormal;
		
	// TEXCOORD PIPELINE (texture space is 2D)
	mat4 atlasMat = mat4(0.5, 0.0, 0.0, 0.0,
						 0.0, 0.5, 0.0, 0.0,
						 0.25, 0.0, 1.0, 0.0,
						 0.25, 0.0, 0.0, 1.0);
	vec4 uv_atlas = atlasMat * aTexcoord;
	
	
	//position in clip space
	//vec4 pos_clip = uProjMat * pos_view;
	//vec4 pos_clip = uViewProjMat * pos_world;
	//vec4 pos_clip = uViewProjMat * uModelMat * aPosition;
	//gl_Position = pos_clip;
	
	//vColor = vec4(1.0,0.5,0.0,1.0);
	//vColor = pos_view;
	
	//DEBUGING 
	//PER_VERTEX : output is final Color
	//vColor = aPosition;
	// example: output normal as color
	//vColor = vec4(aNormal * 0.5 + 0.5,1.0);
	
	//PER_FRAGMENT: OUTPUT anything fragment shader needs to calc final color
	vNormal1 = vec4(aNormal,0.0);
	vNormal2 = vec4(nrm_view,0.0);		
	
	//vTexcoord = aTexcoord;	
	vTexcoord = uv_atlas;
	//gl_Position = /*uProjMat * modlViewMat * */ aTexcoord;
		
	//light setup
	pointLight light1,light2,light3;
	initLight(light1, vec3(-1.0,0.0,0.0),vec3(1.0,1.0,1.0),10.0);
	initLight(light2, vec3(0.0,-1.0,1.0),vec3(1.0,1.0,1.0),10.0);
	initLight(light3, vec3(1.0,0.0,-1.0),vec3(1.0,1.0,1.0),10.0);
	
	
	
	//vTexcoord = vec4( lightCombo(light1,light2,light3,aNormal,aPosition.xyz,uv_atlas.xyz,nrm_view),1.0);

	//vTexcoord = vec4( lightCombo(light1,light2,light3,aNormal,aPosition.xyz,uv_atlas.xyz,aPosition.xyz),1.0);


}