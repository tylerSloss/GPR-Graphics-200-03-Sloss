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



vec3 ray_color(const ray& r) {
    float t = hit_sphere(vec3(0, 0, -1), 0.5, r);
    if (t > 0.0) {
        vec3 N = unit_vector(vec3(r.at(t).x, r.at(t).y,r.at(t).z - -1));
        vec3 temp((N.x + 1) * 0.5, (N.y + 1) * 0.5, (N.z + 1) * 0.5);
        return temp;
    }
	vec3 unit_direction = unit_vector(r.direction());
	float t = 0.5f * (unit_direction.y + 1.0f);
	vec3 temp(((1.0f - t) * 1.0f + t * 0.5f), ((1.0f - t) * 1.0f + t * 0.7f), ((1.0f - t) * 1.0f + t * 1.0f));
	return temp;
}

#endif