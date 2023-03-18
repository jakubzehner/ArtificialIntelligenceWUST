module utils

import simple_time
import position { Position }

fn cached_position(lat string, lon string, mut pos_cache map[string]Position) Position {
	cords := '${lat};${lon}'
	if cords in pos_cache {
		return pos_cache[cords]
	}

	pos := position.from(lat, lon)
	pos_cache[cords] = pos
	return pos
}

fn parse_row(row_str string, mut pos_cache map[string]Position) Row {
	row := row_str.split(',')

	line := row[3]
	start_time := simple_time.from(row[4])
	end_time := simple_time.from(row[5])
	start_stop := row[6].to_lower()
	end_stop := row[7].to_lower()
	start_pos := cached_position(row[8], row[9], mut pos_cache)
	end_pos := cached_position(row[10], row[11], mut pos_cache)

	return Row{line, start_time, end_time, start_stop, end_stop, start_pos, end_pos}
}
