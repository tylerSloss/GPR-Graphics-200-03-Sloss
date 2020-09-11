#pragma once
#ifndef RAY_H
#define RAY_H
/*
    include-ray.h
    ray class for more complex vector math.

    Modified by: Tyler Sloss & Daniel VanRyn
    Modified because: added, altered, and fixed functionality of code from "Ray Tracing in One Weekend" to work with the rest of program
*/
/*
Ray Tracing in One Weekend. raytracing.github.io/books/RayTracingInOneWeekend.html
Accessed 9 10. 2020.

*/


#include "gpro/gpro-math/gproVector.h"

/*
Adapted from Ray Tracing in One Weekend, data structure for more complex 3d vector math
*/
class ray {
public:
    ray() {}
    ray(const vec3& origin, const vec3& direction)
        : orig(origin), dir(direction)
    {}

    vec3 origin() const { return orig; }
    vec3 direction() const { return dir; }
  

    vec3 at(float t) const {
        vec3 temp(orig.x + t * dir.x,orig.y + t * dir.y, orig.z + t * dir.z);
        return temp;
    }

public:
    vec3 orig;
    vec3 dir;
};

#endif