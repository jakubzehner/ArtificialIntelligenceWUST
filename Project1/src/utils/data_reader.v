module utils

import os
import time

pub fn read_csv(path string) !Rows {
	mut rows := Rows{rows: []Row{cap: 273500}}

	start_reading_file_time := time.now()

	content := os.read_file(path)!

	start_parsing_file_time := time.now()
	eprintln("Csv file loading time: ${start_parsing_file_time - start_reading_file_time}")

	for line in content.split('\n')[1..] {
		rows.rows << parse_row(line)
	}

	eprintln("Csv parsing time: ${time.now() - start_parsing_file_time}")
	eprintln("Loaded rows of data: ${rows.rows.len}")

	return rows
}
