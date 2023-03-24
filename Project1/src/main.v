module main

import utils
import graph
import os

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
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Lubiatów', '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('pl. Zgody (Muzeum Etnograficzne)', 'Chełmońskiego', '12:00:00', graph.Cost.p, public_transport_graph)
	//
	// graph.dijkstra('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.t, public_transport_graph)
	// graph.a_star('KRZYKI', 'BISKUPIN', '11:11:00', graph.Cost.p, public_transport_graph)
}

fn user_interface(g graph.Graph) {
	for {
		println('1. Dijkstra')
		println('2. A*')
		println('3. Tabu Search')
		alg := os.input('Wybierz algorytm: ')
		match alg {
			'1' {
				start, time := read_start()
				end := os.input('Podaj przystanek końcowy: ')
				version := pick_version() or { continue }
				graph.dijkstra(start, end, time, version, g)
			}
			'2' {
				start, time := read_start()
				end := os.input('Podaj przystanek końcowy: ')
				version := pick_version() or { continue }
				graph.a_star(start, end, time, version, g)
			}
			'3' {
				start, time := read_start()
				list := os.input('Podaj listę przystanków do odwiedzenia (oddzielonych ;): ')
				version := pick_version() or { continue }
				graph.tabu_search(start, list.split(';'), time, version, g)
			}
			else {
				println('Nieprawidłowy wybór')
				continue
			}
		}
	}
}

fn read_start() (string, string) {
	start := os.input('Podaj przystanek początkowy: ')
	time := os.input('Podaj czas na przystanku początkowym (w formacie 00:00:00): ')
	return start, time
}

fn pick_version() ?graph.Cost {
	version := os.input('Podaj rodzaj funkcji kosztu (t/p): ')
	return match version {
		't' {
			.t
		}
		'p' {
			.p
		}
		else {
			println('Nieprawidłowy wybór')
			none
		}
	}
}
