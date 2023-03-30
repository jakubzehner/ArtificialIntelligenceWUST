module main

import utils
import graph
import os

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	public_transport_graph := graph.build_graph(rows)
	user_interface(public_transport_graph)
}

//TODO: refactor and switch to English
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
				g.dijkstra(start, end, time, version)
			}
			'2' {
				start, time := read_start()
				end := os.input('Podaj przystanek końcowy: ')
				version := pick_version() or { continue }
				g.a_star(start, end, time, version)
			}
			'3' {
				start, time := read_start()
				list := os.input('Podaj listę przystanków do odwiedzenia (oddzielonych ;): ')
				version := pick_version() or { continue }
				g.tabu_search(start, list.split(';'), time, version)
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

fn pick_version() ?graph.CostSelector {
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
