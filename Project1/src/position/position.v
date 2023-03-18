module position

import math.vec { Vec2 }

pub struct Position {
	x f32
	y f32
}

pub fn (pos Position) str() string {
	return 'x: ${pos.x} y: ${pos.y}'
}

pub fn (pos Position) distance_to(other Position) f32 {
	return pos.to_vector().distance(other.to_vector())
}

pub fn from(lat_str string, lon_str string) Position {
	lat, lon := lat_str.f64(), lon_str.f64()
	x, y := convert_wgs84_to_position(lat, lon)
	return Position{f32(x), f32(y)}
}

pub fn (pos Position) to_vector() Vec2[f32] {
	return vec.vec2(pos.x, pos.y)
}

pub fn (pos Position) short_str() string {
	return '${pos.x},${pos.y}'
}
