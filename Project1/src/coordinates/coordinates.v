module coordinates

import math.vec

pub struct Coordinates {
	x f64
	y f64
}

pub fn (cord Coordinates) str() string {
	return 'x: ${cord.x} y: ${cord.y}'
}

pub fn (cord Coordinates) distance_to(other Coordinates) f64 {
	return cord.to_vector().distance(other.to_vector())
}

pub fn from(lat_str string, lon_str string) Coordinates {
	lat, lon := lat_str.f64(), lon_str.f64()
	x, y := convert_wgs84_to_position(lat, lon)
	return Coordinates{x, y}
}

pub fn (cord Coordinates) to_vector() vec.Vec2[f64] {
	return vec.vec2(cord.x, cord.y)
}
