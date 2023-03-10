// Jakub Zehner 2023
module main

import time
import encoding.csv
import os
import simple_time
import coordinates

fn parse_csv_row(row []string) Link {
	id := row[1].int()
	line := row[3]
	start_time := simple_time.from(row[4])
	end_time := simple_time.from(row[5])
	start_stop := row[6].to_lower()
	end_stop := row[7].to_lower()
	start_cord := coordinates.from(row[8], row[9])
	end_cord := coordinates.from(row[10], row[11])

	return Link{id, line, start_time, end_time, start_stop, end_stop, start_cord, end_cord}
}

fn read_data() ! {
	mut arr := []Link{cap: 273500}

	start_time := time.now()
	content := os.read_file('../data/connection_graph.csv')!
	after_loading_time := time.now()
	println('File loading time: ${after_loading_time - start_time}')

	mut reader := csv.new_reader(content)
	reader.read()! // Skip the first line
	for {
		row := reader.read() or { break }
		arr << parse_csv_row(row)
	}
	println('Csv parsing time: ${time.now() - after_loading_time}')
	println('Loaded rows from csv: ${arr.len}')
	println(arr[0])
}
