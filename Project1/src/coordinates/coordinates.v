module coordinates

import math

pub struct Coordinates {
	x f64
	y f64
}

pub fn (cord Coordinates) str() string {
	return 'x: ${cord.x} y: ${cord.y}'
}

pub fn (cord Coordinates) distance_to(other Coordinates) f64 {
	return math.sqrt(math.pow(cord.x - other.x, 2) + math.pow(cord.y - other.y, 2))
}

pub fn from(lat_str string, lon_str string) Coordinates {
	lat, lon := lat_str.f64(), lon_str.f64()
	x, y := convert_wgs84_to_position(lat, lon)
	return Coordinates{x, y}
}
