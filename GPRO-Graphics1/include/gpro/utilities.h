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