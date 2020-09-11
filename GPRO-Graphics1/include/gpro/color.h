#pragma once
#ifndef COLOR_H
#define COLOR_H
/*
Ray Tracing in One Weekend. raytracing.github.io/books/RayTracingInOneWeekend.html
Accessed 9 10. 2020.

*/

#include "gpro/gpro-math/gproVector.h"
#include "ray.h"
#include "utilities.h"

#include <iostream>

void write_color(std::ostream& out, vec3 pixel_color) {
    // Write the translated [0,255] value of each color component.
    out << static_cast<int>(255.999 * pixel_color.x) << ' '
        << static_cast<int>(255.999 * pixel_color.y) << ' '
        << static_cast<int>(255.999 * pixel_color.z) << '\n';
}

bool hit_sphere(const vec3& center, double radius, const ray& r) {
	vec3 oc(r.origin().x - center.x, r.origin().y - center.y, r.origin().z - center.z);
	float a = dot(r.direction(), r.direction());
	float b = 2.0 * dot(oc, r.direction());
	float c = dot(oc, oc) - radius * radius;
	float discriminant = b * b - 4 * a * c;
	return (discriminant > 0);
}

vec3 ray_color(const ray& r) {
	if (hit_sphere(vec3(0, 0, -1), 0.5, r))
		return vec3(1, 0, 0);
	vec3 unit_direction = unit_vector(r.direction());
	float t = 0.5f * (unit_direction.y + 1.0f);
	vec3 temp(((1.0f - t) * 1.0f + t * 0.5f), ((1.0f - t) * 1.0f + t * 0.7f), ((1.0f - t) * 1.0f + t * 1.0f));
	return temp;
}

#endif