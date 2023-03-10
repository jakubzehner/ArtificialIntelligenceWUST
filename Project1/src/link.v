// Jakub Zehner 2023
module main

import simple_time
import coordinates

struct Link {
	id         int
	line       string
	start_time simple_time.SimpleTime
	end_time   simple_time.SimpleTime
	start_stop string
	end_stop   string
	start_cord coordinates.Coordinates
	end_cord   coordinates.Coordinates
}
