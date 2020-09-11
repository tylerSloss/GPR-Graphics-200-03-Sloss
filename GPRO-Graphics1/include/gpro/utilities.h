#pragma once
#ifndef UTILITIES_H
#define UTILITIES_H

#include "gpro/gpro-math/gproVector.h"
#include <math.h>

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