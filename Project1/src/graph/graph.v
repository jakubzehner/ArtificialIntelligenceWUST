module graph

import simple_time { SimpleTime }
import term

pub enum CostSelector {
	t
	p
}

pub struct Graph {
	pos_to_name       map[string]string
	name_to_nodes_ids map[string][]int
	edges             [][]Edge
	nodes             []Node
}

pub fn (g Graph) dijkstra(start string, end string, start_time string, cost_choice CostSelector) {
	if !g.check_if_name_exists(start) || !g.check_if_name_exists(end) {
		return
	}

	println('Dijkstra ${cost_name(cost_choice)} -- ${start} --> ${end}')

	cost_manager := match cost_choice {
		.t {
			CostManager{
				use_heuristic: false
				heuristic: dummy_heuristic
				cost_function: simple_time_cost
			}
		}
		.p {
			CostManager{
				use_heuristic: false
				heuristic: dummy_heuristic
				cost_function: transfer_time_cost
			}
		}
	}

	start_id := g.find_nearest_node(start, start_time) or { return }
	path, travel_time, transfers, runtime := g.find_path(start_id, end, cost_manager) or { return }

	g.show_path_result(path)
	eprintln(term.gray('Travel time: ${SimpleTime{u16(travel_time)}.time_str()} (${travel_time} min)'))
	eprintln(term.gray('Transfers: ${transfers}'))
	eprintln(term.gray('Runtime: ${runtime}'))
}

pub fn (g Graph) a_star(start string, end string, start_time string, cost_choice CostSelector) {
	if !g.check_if_name_exists(start) || !g.check_if_name_exists(end) {
		return
	}

	println('A* ${cost_name(cost_choice)} -- ${start} --> ${end}')

	cost_manager := match cost_choice {
		.t {
				CostManager{
				use_heuristic: true
				heuristic: heuristic_distance
				cost_function: simple_time_cost
			}
		}
		.p {
				CostManager{
				use_heuristic: true
				heuristic: heuristic_distance
				cost_function: transfer_penalty_time_cost
			}
		}
	}

	start_id := g.find_nearest_node(start, start_time) or { return }
	path, travel_time, transfers, runtime := g.find_path(start_id, end, cost_manager) or { return }

	g.show_path_result(path)
	eprintln(term.gray('Travel time: ${SimpleTime{u16(travel_time)}.time_str()} (${travel_time} min)'))
	eprintln(term.gray('Transfers: ${transfers}'))
	eprintln(term.gray('Runtime: ${runtime}'))
}

pub fn tabu_search(start string, stops []string, start_time string, cost_function CostSelector, g Graph) {
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
