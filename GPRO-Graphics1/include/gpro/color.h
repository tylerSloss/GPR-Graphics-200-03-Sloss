#pragma once
#ifndef COLOR_H
#define COLOR_H
/*
    include-gpro-color.h
    Writes and reads color for the application.

    Modified by: Tyler Sloss & Daniel VanRyn
    Modified because: added, altered, and fixed functionality of code from "Ray Tracing in One Weekend" to work with the rest of program
*/
/*
Ray Tracing in One Weekend. raytracing.github.io/books/RayTracingInOneWeekend.html
Accessed 9 10. 2020.

*/

#include "gpro/gpro-math/gproVector.h"
#include "ray.h"
#include "utilities.h"

#include <iostream>
#include <gpro\hittable_list.h>
#include <gpro\rtweekend.h>

/*
Adapted from Ray Tracing in One Weekend, outputs color values for verification
*/
void write_color(std::ostream& out, vec3 pixel_color) {
    // Write the translated [0,255] value of each color component.
    out << static_cast<int>(255.999 * pixel_color.x) << ' '
        << static_cast<int>(255.999 * pixel_color.y) << ' '
        << static_cast<int>(255.999 * pixel_color.z) << '\n';
}


/*
Adapted from Ray Tracing in One Weekend, identifies the color at a point on the ray
*/
vec3 ray_color(const ray& r, const hittable& world) {
    hit_record rec;
    if (world.hit(r, 0, infinity, rec)) {
        vec3 temp((rec.normal.x + 1) * 0.5f, (rec.normal.y + 1) * 0.5f, (rec.normal.z + 1) * 0.5f);
        return temp;
    }

	vec3 unit_direction = unit_vector(r.direction());
    float t = static_cast<float>(0.5 * (unit_direction.y + 1.0));
	vec3 temp(((1.0f - t) * 1.0f + t * 0.5f), ((1.0f - t) * 1.0f + t * 0.7f), ((1.0f - t) * 1.0f + t * 1.0f));
	return temp;
}

#endif