module main

import utils
import graph

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	public_transport_graph := graph.build_graph(rows)
	user_interface(public_transport_graph)
	// public_transport_graph.stats()
	// Nodes: 272814
	// Edges: 1316764

	// graph.tabu_search('Rynek', [
	// 	'Świdnicka',
	// 	'GALERIA DOMINIKAŃSKA',
	// 	'Hala Targowa',
	// ], '12:00:00', graph.Cost.t, public_transport_graph)
	//
	// graph.tabu_search('Rynek', [
	// 	'Świdnicka',
	// 	'GALERIA DOMINIKAŃSKA',
	// 	'Hala Targowa',
	// ], '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.tabu_search('pl. Zgody (Muzeum Etnograficzne)', [
	// 	'GALERIA DOMINIKAŃSKA',
	// 	'DWORZEC GŁÓWNY',
	// 	'Kamienna',
	// 	'Hallera',
	// 	'FAT',
	// 	'Niedźwiedzia',
	// 	'Bałtycka',
	// 	'Grudziądzka',
	// 	'Kochanowskiego',
	// 	'PL. GRUNWALDZKI',
	// ], '12:00:00', graph.Cost.t, public_transport_graph)
	//
	// graph.tabu_search('pl. Zgody (Muzeum Etnograficzne)', [
	// 	'GALERIA DOMINIKAŃSKA',
	// 	'DWORZEC GŁÓWNY',
	// 	'Kamienna',
	// 	'Hallera',
	// 	'FAT',
	// 	'Niedźwiedzia',
	// 	'Bałtycka',
	// 	'Grudziądzka',
	// 	'Kochanowskiego',
	// 	'PL. GRUNWALDZKI',
	// ], '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('Kątna', 'Lubiatów', '12:40:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('Kątna', 'Lubiatów', '12:40:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('Kątna', 'Lubiatów', '12:40:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.t, public_transport_graph)
	graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.p, public_transport_graph)
}

fn user_interface(g graph.Graph) {

}
