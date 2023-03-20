module main

import utils
import graph

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	mpk_graph := graph.build_graph(rows)
	mpk_graph.stats()
	graph.dijkstra('Kątna', 'Lubiatów', '12:41:00', mpk_graph)
}
