// Jakub Zehner 2023
module main

import coordinates
import math

fn main() {
	//read_data()!
	// println(math.radians(51.11038700))
	// println(math.radians(17.03102025))

	c0 := coordinates.from("51.11038700", "17.03102025")
	println(c0)

	c1 := coordinates.from("51.16042707", "17.12241711")
	c2 := coordinates.from("51.16201253", "17.12469012")
	println(c1.distance_to(c2))
}
