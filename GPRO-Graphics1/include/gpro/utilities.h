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

#endif