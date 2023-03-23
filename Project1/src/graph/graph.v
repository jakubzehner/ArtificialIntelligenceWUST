module graph

import term
import simple_time { SimpleTime }

pub const walking_speed = f32(4) / f32(60) // in km per minute

pub enum Cost {
	t
	p
}

pub struct Graph {
	pos_to_name       map[string]string
	name_to_nodes_ids map[string][]int
	edges             [][]Edge
	nodes             []Node
}

pub fn dijkstra(start string, end string, start_time string, cost_function Cost, g Graph) {
	if cost_function == .p {
		println('Dijkstra ${cost_name(cost_function)} is not supported!')
		return
	}
	if !check_if_name_exists(start, g) || !check_if_name_exists(end, g) {
		return
	}

	println('Dijkstra ${cost_name(cost_function)} -- ${start} --> ${end}')
	start_id := find_nearest_node(start, start_time, g)

	path, cost, runtime := dijkstra_alg(start_id, end, g)
	show_path_result(path, g)
	eprintln(term.gray('Cost: ${SimpleTime{u16(cost)}.time_str()} (${cost} min)'))
	eprintln(term.gray('Runtime: ${runtime}'))
}

pub fn a_star(start string, end string, start_time string, cost_function Cost, g Graph) {
	if !check_if_name_exists(start, g) || !check_if_name_exists(end, g) {
		return
	}

	println('A* ${cost_name(cost_function)} -- ${start} --> ${end}')
	start_id := find_nearest_node(start, start_time, g)

	path, cost, runtime := match cost_function {
		.t { a_star_time_alg(start_id, end, g) }
		.p { a_star_transfer_alg(start_id, end, g) }
	}

	show_path_result(path, g)
	match cost_function {
		.t { eprintln(term.gray('Cost: ${SimpleTime{u16(cost)}.time_str()} (${cost} min)')) }
		.p { eprintln(term.gray('Cost: ${cost} transfers')) }
	}
	eprintln(term.gray('Runtime: ${runtime}'))
}

pub fn tabu_search (start string, stops []string, start_time string, cost_function Cost, g Graph) {
	if !check_if_name_exists(start, g) {
		return
	}
	for stop in stops {
		if !check_if_name_exists(stop, g) {
			return
		}
	}

	start_id := find_nearest_node(start, start_time, g)

	paths, cost, runtime, solution := match cost_function {
		.t { tabu_search_time_alg(start_id, stops, g) }
		.p { tabu_search_transfer_alg(start_id, stops, g) }
	}

	println('Tabu Search ${cost_name(cost_function)} -- ${start}, ${solution}')
	for path in paths {
		show_path_result(path, g)
	}

	match cost_function {
		.t { eprintln(term.gray('Cost: ${SimpleTime{u16(cost)}.time_str()} (${cost} min)')) }
		.p { eprintln(term.gray('Cost: ${cost} transfers')) }
	}
	eprintln(term.gray('Runtime: ${runtime}'))
}

pub fn (graph Graph) stats() {
	mut edges_n := 0
	for edge in graph.edges {
		edges_n += edge.len
	}
	println('Nodes: ${graph.nodes.len}')
	println('Edges: ${edges_n}')
}
