#pragma once
#ifndef SPHERE_H
#define SPHERE_H

#include "hittable.h"
#include "gpro-math/gproVector.h"

class sphere : public hittable {
public:
    sphere() { }
    sphere(vec3 cen, double r) : center(cen), radius(r) {};

    virtual bool hit(
        const ray& r, double tmin, double tmax, hit_record& rec) const override;

public:
    vec3 center;
    double radius = 0;
};

bool sphere::hit(const ray& r, double t_min, double t_max, hit_record& rec) const {
    vec3 oc(r.origin().x - center.x, r.origin().y - center.y, r.origin().z - center.z);
    double a = r.direction().length_squared();
    double half_b = dot(oc, r.direction());
    double c = oc.length_squared() - radius * radius;
    double discriminant = half_b * half_b - a * c;

    if (discriminant > 0) {

        float root = static_cast<float>(sqrt(discriminant));
        float temp = static_cast<float>((-half_b - root) / a);

        if (temp < t_max && temp > t_min) {
            rec.t = temp;
            rec.p = r.at(static_cast<float>(rec.t));
            vec3 outward_normal(static_cast<float>((static_cast<double>(rec.p.x) - static_cast<float>(center.x)) / radius, (static_cast<double>(rec.p.y) - static_cast<double>(center.y)) / radius, (static_cast<double>(rec.p.y) - static_cast<float>(center.y)) / radius));
            rec.set_face_normal(r, outward_normal);
            return true;
        }

        temp = static_cast<float>((-half_b + root) / a);
        if (temp < t_max && temp > t_min) {
            rec.t = temp;
            rec.p = r.at(static_cast<float>(rec.t));
            vec3 outward_normal(static_cast<float>((static_cast<double>(rec.p.x) - static_cast<float>(center.x)) / radius, (static_cast<double>(rec.p.y) - static_cast<float>(center.y)) / radius, (static_cast<double>(rec.p.y) - static_cast<float>(center.y)) / radius));
            rec.set_face_normal(r, outward_normal);
            return true;
        }
    }

    return false;
}


#endif