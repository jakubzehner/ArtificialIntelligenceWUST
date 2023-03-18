module utils

import position { Position }
import simple_time { SimpleTime }

pub struct Row {
pub:
	line       string
	start_time SimpleTime
	end_time   SimpleTime
	start_stop string
	end_stop   string
	start_pos  Position
	end_pos    Position
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
