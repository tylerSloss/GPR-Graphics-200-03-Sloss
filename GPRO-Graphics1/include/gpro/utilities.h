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
	auto a = r.direction().length_squared();
	auto half_b = dot(oc, r.direction());
	auto c = oc.length_squared() - radius * radius;
	auto discriminant = half_b * half_b - a * c;
	if (discriminant < 0) {
		return false;
	}
	else {
		return (-half_b - sqrt(discriminant)) / a;
	}
	return (discriminant > 0);
}

#endif