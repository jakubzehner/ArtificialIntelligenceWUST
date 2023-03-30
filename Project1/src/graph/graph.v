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

pub fn (g Graph) tabu_search(start string, stops []string, start_time string, cost_choice CostSelector) {
	if !g.check_if_name_exists(start) {
		return
	}
	for stop in stops {
		if !g.check_if_name_exists(stop) {
			return
		}
	}

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
	paths, travel_time, transfers, runtime, solution := g.knox(start_id, stops, cost_manager,
		cost_choice)

	println('Tabu Search ${cost_name(cost_choice)} -- ${start}, ${solution}')
	for path in paths {
		g.show_path_result(path)
	}
	eprintln(term.gray('Travel time: ${SimpleTime{u16(travel_time)}.time_str()} (${travel_time} min)'))
	eprintln(term.gray('Transfers: ${transfers}'))
	eprintln(term.gray('Runtime: ${runtime}'))
}

//TODO: remove after graph builder refactor
pub fn (graph Graph) stats() {
	mut edges_n := 0
	for edge in graph.edges {
		edges_n += edge.len
	}
	println('Nodes: ${graph.nodes.len}')
	println('Edges: ${edges_n}')
}
