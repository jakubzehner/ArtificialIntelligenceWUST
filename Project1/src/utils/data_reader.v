module utils

import os
import term
import time

import position { Position }

pub fn read_csv(path string) !Rows {
	mut pos_cache := map[string]Position{}
	mut rows := Rows{
		rows: []Row{cap: 273500}
	}

	start_reading_file_time := time.now()

	content := os.read_file(path)!

	start_parsing_file_time := time.now()
	eprintln(term.gray('Csv file loading time: ${start_parsing_file_time - start_reading_file_time}'))

	for line in content.split('\n')[1..] {
		rows.rows << parse_row(line, mut pos_cache)
	}

	eprintln(term.gray('Csv parsing time: ${time.now() - start_parsing_file_time}'))

	return rows
}
