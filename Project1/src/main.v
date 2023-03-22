module main

import utils
import graph

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	public_transport_graph := graph.build_graph(rows)
	public_transport_graph.stats()
	//Nodes: 272814
	//Edges: 1316764

	graph.dijkstra('Kątna', 'Lubiatów', '12:40:00', graph.Cost.t, public_transport_graph)
	graph.a_star('Kątna', 'Lubiatów', '12:40:00', graph.Cost.t, public_transport_graph)
	graph.a_star('Kątna', 'Lubiatów', '12:40:00', graph.Cost.p, public_transport_graph)

	graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.t, public_transport_graph)
	graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.t, public_transport_graph)
	graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.p, public_transport_graph)

	graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.p, public_transport_graph)

	graph.dijkstra('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.p, public_transport_graph)
}
