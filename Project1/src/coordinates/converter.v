module coordinates

import math
import math.vec

const (
	center_lat    = 0.8920445351185071 // 51.11038700
	center_lon    = 0.2972473783363278 // 17.03102025
	center_radius = 6365.343

	std_vec = vec.vec3(1.0, 0.0, 0.0)
)

fn convert_wgs84_to_position(lat f64, lon f64) (f64, f64) {
	v := convert_geographic_to_cartesian(math.radians(lat), math.radians(lon))
	rx, ry := project_3d_point_to_2d_plane(v)
	return rx, ry
}

fn convert_geographic_to_cartesian(lat f64, lon f64) vec.Vec3[f64] {
	// https://stackoverflow.com/questions/1185408/converting-from-longitude-latitude-to-cartesian-coordinates
	x := coordinates.center_radius * math.cos(lat) * math.cos(lon)
	y := coordinates.center_radius * math.cos(lat) * math.sin(lon)
	z := coordinates.center_radius * math.sin(lat)

	return vec.vec3(x, y, z)
}

// I always knew that earth is flat
fn project_3d_point_to_2d_plane(v vec.Vec3[f64]) (f64, f64) {
	normal := convert_geographic_to_cartesian(coordinates.center_lat, coordinates.center_lon)
	v1 := magic1(v, normal)
	resx, resy := magic2(v1, normal)
	return resx, resy
}

fn magic1(point vec.Vec3[f64], normal vec.Vec3[f64]) vec.Vec3[f64] {
	// https://www.baeldung.com/cs/3d-point-2d-plane
	k := normal.dot(point) / normal.magnitude()
	res := point + normal.mul_scalar(k)
	return res
}

fn magic2(point vec.Vec3[f64], normal vec.Vec3[f64]) (f64, f64) {
	// https://math.stackexchange.com/questions/2450745/finding-orthogonal-vectors-in-a-plane
	v1 := normal.cross(std_vec).unit()
	v2 := normal.cross(v1).unit()

	resx := point.dot(v1)
	resy := point.dot(v2)

	return resx, resy
}
