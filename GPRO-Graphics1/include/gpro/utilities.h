#pragma once
#ifndef UTILITIES_H
#define UTILITIES_H

#include "gpro/gpro-math/gproVector.h"
#include <math.h>

vec3 unit_vector(vec3 dir)
{
	float scale = sqrt((dir.x * dir.x) + (dir.y * dir.y) + (dir.z * dir.z));
	dir.x = dir.x / scale;
	dir.y = dir.y / scale;
	dir.z = dir.z / scale;
	return dir;
}

#endif