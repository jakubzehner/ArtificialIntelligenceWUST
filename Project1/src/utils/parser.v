module utils

import simple_time { from }
import coordinates

fn parse_row(row_str string) Row {
	row := row_str.split(',')

	line := row[3]
	start_time := from(row[4])
	end_time := from(row[5])
	start_stop := row[6].to_lower()
	end_stop := row[7].to_lower()
	start_cord := coordinates.from(row[8], row[9])
	end_cord := coordinates.from(row[10], row[11])

	return Row{line, start_time, end_time, start_stop, end_stop, start_cord, end_cord}
}
