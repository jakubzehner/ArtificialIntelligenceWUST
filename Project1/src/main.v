module main

import utils
import graph
import os

fn main() {
	rows := utils.read_csv('./data/connection_graph.csv')!
	public_transport_graph := graph.build_graph(rows)
	user_interface(public_transport_graph)
}

fn user_interface(g graph.Graph) {
	for {
		println('Available algorithms:')
		println('1. Dijkstra')
		println('2. A*')
		println('3. Tabu Search')
		match os.input('Choose algorithm [1/2/3]: ') {
			'1' {
				start, time := read_start()
				end := os.input('End stop: ')
				version := pick_version() or { continue }
				g.dijkstra(start, end, time, version)
			}
			'2' {
				start, time := read_start()
				end := os.input('End stop: ')
				version := pick_version() or { continue }
				g.a_star(start, end, time, version)
			}
			'3' {
				start, time := read_start()
				list := os.input('Stops list [separated with ;]: ')
				version := pick_version() or { continue }
				g.tabu_search(start, list.split(';'), time, version)
			}
			else {
				println('Incorrect choice')
				continue
			}
		}
	}
}

fn read_start() (string, string) {
	start := os.input('Start stop: ')
	time := os.input('Start time [HH:mm]: ')
	return start, time
}

fn pick_version() ?graph.CostSelector {
	version := os.input('Cost function (t - time, p - transfers) [t/p]: ')
	return match version {
		't' {
			.t
		}
		'p' {
			.p
		}
		else {
			println('Incorrect choice')
			none
		}
	}
}
