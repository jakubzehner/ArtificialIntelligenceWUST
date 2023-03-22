module main

import utils
import graph

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	mpk_graph := graph.build_graph(rows)
	mpk_graph.stats()
	graph.dijkstra('Kątna', 'Lubiatów', '12:40:00', mpk_graph)
	graph.a_star_time('Kątna', 'Lubiatów', '12:40:00', mpk_graph)
	graph.a_star_transfer('Kątna', 'Lubiatów', '12:40:00', mpk_graph)

	graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', mpk_graph)
	graph.a_star_time('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', mpk_graph)
	graph.a_star_transfer('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', mpk_graph)

	graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', mpk_graph)
	graph.a_star_time('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', mpk_graph)
	graph.a_star_transfer('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', mpk_graph)

	graph.dijkstra('KRZYKI', 'BISKUPIN', '11:11:00', mpk_graph)
	graph.a_star_time('KRZYKI', 'BISKUPIN', '11:11:00', mpk_graph)
	graph.a_star_transfer('KRZYKI', 'BISKUPIN', '11:11:00', mpk_graph)

}
