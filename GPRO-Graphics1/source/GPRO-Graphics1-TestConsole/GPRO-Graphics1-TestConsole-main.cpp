/*
   Copyright 2020 Daniel S. Buckstein

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/*
	GPRO-Graphics1-TestConsole-main.c/.cpp
	Main entry point source file for a Windows console application.

	Modified by: Tyler Sloss
	Modified because: ____________
*/
/*
Ray Tracing in One Weekend. raytracing.github.io/books/RayTracingInOneWeekend.html
Accessed 9 10. 2020.

*/


#include <stdio.h>
#include <stdlib.h>


#include "gpro/gpro-math/gproVector.h"
#include "gpro/color.h"


void testVector()
{
	// test array vector initializers and functions
	float3 av, bv, cv, dv;
	vec3default(av);								// -> a = (0, 0, 0)
	vec3init(bv, 1.0f, 2.0f, 3.0f);					// -> b = (1, 2, 3)
	vec3copy(dv, vec3init(cv, 4.0f, 5.0f, 6.0f));	// -> d = c = (4, 5, 6)
	vec3copy(av, dv);								// a = d			-> a = (4, 5, 6)
	vec3add(dv, bv);								// d += b			-> d = (4 + 1, 5 + 2, 6 + 3) = (5, 7, 9)
	vec3sum(dv, bv, bv);							// d = b + b		-> d = (1 + 1, 2 + 2, 3 + 3) = (2, 4, 6)
	vec3add(vec3sum(dv, cv, bv), av);				// d = c + b + a	-> d = (4 + 1 + 4, 5 + 2 + 5, 6 + 3 + 6) = (9, 12, 15)

#ifdef __cplusplus
	// test all constructors and operators
	vec3 a, b(1.0f, 2.0f, 3.0f), c(cv), d(c);		// default; init; copy array; copy
	a = d;											// assign						-> a = (4, 5, 6)
	d += b;											// add assign					-> d = (5, 7, 9)
	d = b + b;										// sum, init, assign			-> d = (2, 4, 6)
	d = c + b + a;									// sum, init, sum, init, assign	-> d = (9, 12, 15)
#endif	// __cplusplus
}



#ifdef __cplusplus
// Includes for C++
#include <fstream>
#include <iostream>
#include <string>
#else   // !__cplusplus
// includes for C
#include <stdio.h>
#endif // __cplusplus



int main(int const argc, char const* const argv[])
{
	testVector();

#ifdef __cplusplus
	std::ofstream file("raytrace.ppm"); // open file for writing
	//std::string test = "hello cpp";        // string to write 
	
	
#else // !__cplusplus
	FILE* fp = fopen("openpls.txt", "w"); // open file for writing
	if (fp) 
	{
		char test[] = "hello C";				// string to write 
		fprintf(fp, "%s\n", test);			// write string and newline
		fclose(fp);
	}
	
#endif // __cplusplus

	

	// Image

	const float aspect_ratio = 16.0f / 9.0f;
	const int image_width = 400;
	const int image_height = static_cast<int>(image_width / aspect_ratio);

	// Camera

	float viewport_height = 2.0;
	float viewport_width = aspect_ratio * viewport_height;
	float focal_length = 1.0;

	vec3 origin = vec3(0, 0, 0);
	vec3 horizontal = vec3(viewport_width, 0, 0);
	vec3 vertical = vec3(0, viewport_height, 0);
	vec3 lower_left_corner((origin.x - horizontal.x / 2 - vertical.x / 2) - 0, (origin.y - horizontal.y / 2 - vertical.y / 2) - 0, (origin.z - horizontal.z / 2 - vertical.z / 2) - focal_length);

	// Render

	file << "P3\n" << image_width << ' ' << image_height << "\n255\n";

	 for (int j = image_height-1; j >= 0; --j) {
        std::cerr << "\rScanlines remaining: " << j << ' ' << std::flush;
        for (int i = 0; i < image_width; ++i) {
			float u = float(i) / (image_width - 1);
			float v = float(j) / (image_height - 1);
			vec3 temp(lower_left_corner.x + u * horizontal.x + v * vertical.x - origin.x, lower_left_corner.y + u * horizontal.y + v * vertical.y - origin.y, lower_left_corner.z + u * horizontal.z + v * vertical.z - origin.z);
			ray r(origin, temp);
			vec3 pixel_color = ray_color(r);
			write_color(file, pixel_color);
        }
    }

    std::cerr << "\nDone.\n";

	file.close();						// close file 
	printf("\n\n");
	system("pause");
	}
