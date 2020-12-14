#version 450  
#ifdef GL_ES
precision highp float;
#endif //GL_ES

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


// asPoint: promote a 3D vector into a 4D vector representing a point (w=1)
//    point: input 3D vector
vec4 asPoint(in vec3 point)
{
    return vec4(point, 1.0);
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

in vec4 vPos;

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



float calcAttenuation(pointLight lite, vec3 normal, vec3 position)
{
    float d = lenSq(lite.center.xyz - position);
    return 1.0/(1.0 + sqrt(d)/lite.intensity + d/(lite.intensity * lite.intensity));
}

vec3 calcDiffuseCoefficient(vec3 normal, vec3 position, vec3 liteCent)
{
    return (normal * normalize(liteCent - position));
}

//Labertian Reflectance
vec3 lambertianReflection(in pointLight lite, vec3 normal, vec3 position, vec3 color)
{
    vec3 Id = calcDiffuseCoefficient(normal, position, lite.center.xyz) * calcAttenuation(lite, normal, position);
    return Id;
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
    vec3 Id = lambertianReflection(lite, normal, position, lite.center.xyz) * calcAttenuation(lite, normal, position);
    float Is = calcSpecularIntensity(lite, normal, position, rayDirection);
    vec3 Cs = vec3(1.0, 1.0, 1.0);
    
    return (Id * color + Is * Cs) * lite.color;
}

vec3 lightCombo(in pointLight lite1,in pointLight lite2,in pointLight lite3,in vec3 normal,in vec3 position,in vec3 color,in vec3 rayDirection)
{
	float Ia = 0.3;
    vec3 Ca = vec3(0.7, 0.1, 0.7);
    vec3 combo = phongReflectance(lite1,normal,position,color,rayDirection);
    combo += phongReflectance(lite2,normal,position,color,rayDirection);
    combo += phongReflectance(lite3,normal,position,color,rayDirection);
    return (Ia * Ca) + combo;
}

void main()
{
	rtFragColor = texture(uPlanets[Thing],2.0 * vTexcoord.xy);
	
	
	//rtFragColor = vec4(0.5,1.0,0.0,1.0);
	//PER_VERTEX: just display the final color  
	//rtFragColor = vColor;
	
	//PER_FRAGMENT: calculate and display
	vec4 N = normalize(vNormal1);
	vec4 N2 = normalize(vNormal2);
	vec4 P = normalize(vPos);
	//rtFragColor = vec4(N.xyz * 0.5 + 0.5,1.0);
	
	//rtFragColor = vec4(vTexcoord,0.0,1.0);
	//rtFragColor = vTexcoord;
	
	/*pointLight light1,light2,light3;
	initLight(light1, vec3(-1.0,0.0,0.0),vec3(1.0,1.0,1.0),10.0);
	initLight(light2, vec3(0.0,-1.0,1.0),vec3(1.0,1.0,1.0),10.0);
	initLight(light3, vec3(1.0,0.0,-1.0),vec3(1.0,1.0,1.0),10.0); */
	
	//vTexcoord = vec4( lightCombo(light1,light2,light3,aNormal,aPosition.xyz,uv_atlas.xyz,nrm_view),1.0);
	//rtFragColor *= vec4(lightCombo(light1,light2,light3,N.xyz,vec3(N.xyz * 0.5 + 0.5),texture(uTexture,2.0 * vTexcoord.xy).xyz,vPos.xyz),1.0);
	
	//fragment object space
	//rtFragColor *= vec4(lightCombo(light1,light2,light3,N.xyz,P.xyz,texture(uTexture,2.0 * vTexcoord.xy).xyz,P.xyz),1.0);
	
	//fragment view space
	//rtFragColor *= vec4(lightCombo(light1,light2,light3,N.xyz,P.xyz,texture(uTexture,2.0 * vTexcoord.xy).xyz,N2.xyz),1.0);
	
	//rtFragColor = vec4(0.0);
	//rtFragColor[Thing] = 1.0;
}

