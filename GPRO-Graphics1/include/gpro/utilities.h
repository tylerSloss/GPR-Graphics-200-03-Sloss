#pragma once
#ifndef UTILITIES_H
#define UTILITIES_H
/*
	include-gpro-utilities.h
	additional utilities to aid in calculations to determine what to display.

	Modified by: Tyler Sloss & Daniel VanRyn
	Modified because: added, altered, and fixed functionality of code from "Ray Tracing in One Weekend" to work with the rest of program
*/
/*
Ray Tracing in One Weekend. raytracing.github.io/books/RayTracingInOneWeekend.html
Accessed 9 10. 2020.

*/


#include "gpro/gpro-math/gproVector.h"
#include <math.h>

/*
Adapted from Ray Tracing in One Weekend, calculates the unit vector of a given vector
*/
vec3 unit_vector(vec3 dir)
{
	double temp = pow(dir.x, 2);
	temp += pow(dir.y, 2);
	temp += pow(dir.z, 2);
	double scale = sqrt(temp);
	dir.x = static_cast<float>(dir.x / scale);
	dir.y = static_cast<float>(dir.y / scale);
	dir.z = static_cast<float>(dir.z / scale);
	return dir;
}

/*
Adapted from Ray Tracing in One Weekend, determines whether a ray hits a given sphere (vec3 + radius)
*/
bool hit_sphere(const vec3& center, double radius, const ray& r) {
	vec3 oc(r.origin().x - center.x, r.origin().y - center.y, r.origin().z - center.z);
	float a = dot(r.direction(), r.direction());
	float b = 2.0 * dot(oc, r.direction());
	float c = dot(oc, oc) - radius * radius;
	float discriminant = b * b - 4 * a * c;
	if (discriminant < 0) {
		return -1.0;
	}
	else {
		return (-b - sqrt(discriminant)) / (2.0 * a);
	}
	return (discriminant > 0);
}

#endif