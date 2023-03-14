module coordinates

import math
import math.vec

// center of Wrocław Market Square, latitude, longitude and Earth radius in these coordinates
pub const (
	center_lat    = 0.8920446201811275 // 51.11039187372915 in radians
	center_lon    = 0.2972475237665632 // 17.031028582538703 in radians
	center_radius = 6365.343 // in km
)

// constants needed to calculate 2d cartesian position from coordinates
// https://math.stackexchange.com/questions/2450745/finding-orthogonal-vectors-in-a-plane
const (
	std_vec     = vec.vec3(1.0, 0.0, 0.0)
	normal_vec  = convert_geographic_to_cartesian(center_lat, center_lon)
	basis_vec_1 = convert_geographic_to_cartesian(center_lat, center_lon).cross(std_vec).unit()
	basis_vec_2 = convert_geographic_to_cartesian(center_lat, center_lon).cross(basis_vec_1).unit()
)

// conversion from wgs84 geographic position to cartesian position projected to a plane
// error should be unnoticeably small, because Wrocław is not very big compared to the size of Earth
fn convert_wgs84_to_position(lat f64, lon f64) (f64, f64) {
	position := convert_geographic_to_cartesian(math.radians(lat), math.radians(lon))
	x, y := project_3d_point_to_2d_plane(position)
	return x, y
}

// conversion from wgs84 geographic position to 3d cartesian position
// https://stackoverflow.com/questions/1185408/converting-from-longitude-latitude-to-cartesian-coordinates
fn convert_geographic_to_cartesian(lat f64, lon f64) vec.Vec3[f64] {
	x := center_radius * math.cos(lat) * math.cos(lon)
	y := center_radius * math.cos(lat) * math.sin(lon)
	z := center_radius * math.sin(lat)

	return vec.vec3(x, y, z)
}

// projection 3d cartesian position to 2d position on a plane
// I always knew that earth is flat
// https://www.baeldung.com/cs/3d-point-2d-plane
fn project_3d_point_to_2d_plane(point vec.Vec3[f64]) (f64, f64) {
	k := normal_vec.dot(point) / normal_vec.magnitude()
	projected_point := point + normal_vec.mul_scalar(k)

	x := projected_point.dot(basis_vec_1)
	y := projected_point.dot(basis_vec_2)

	return x, y
}
