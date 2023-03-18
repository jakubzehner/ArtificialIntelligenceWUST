module utils

import position
import simple_time

pub struct Row {
pub:
	line       string
	start_time simple_time.SimpleTime
	end_time   simple_time.SimpleTime
	start_stop string
	end_stop   string
	start_pos position.Position
	end_pos   position.Position
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
