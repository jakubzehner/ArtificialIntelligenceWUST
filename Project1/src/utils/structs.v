module utils

import coordinates
import simple_time

struct Row {
	line       string
	start_time simple_time.SimpleTime
	end_time   simple_time.SimpleTime
	start_stop string
	end_stop   string
	start_cord coordinates.Coordinates
	end_cord   coordinates.Coordinates
}

pub struct Rows {
mut:
	rows []Row
	idx  int
}

pub fn (mut iter Rows) next() ?Row {
	if iter.idx >= iter.rows.len {
		return none
	}
	defer {
		iter.idx++
	}
	return iter.rows[iter.idx]
}
