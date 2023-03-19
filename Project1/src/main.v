module main

import utils
import graph

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	mpk_graph := graph.build_graph(rows)
	mpk_graph.stats()

	// println(math.radians(51.11039187372915))
	// println(math.radians(17.031028582538703))

	// c0 := coordinates.from("51.11039187372915", "17.031028582538703")
	// println(c0)
	//
	// c1 := coordinates.from("51.16042707", "17.12241711")
	// c2 := coordinates.from("51.16201253", "17.12469012")
	// println(c1.distance_to(c2))
}
