module graph

import math
import rand
import time

const (
	iterations_multiplier = 1
	threshold_multiplier  = 2
)

struct Tabu {
	x int
	y int
}

// The shortest cycle, which includes all the given stops, starting and ending at the selected stop at a given hour finding algorithm
// Behaviour depends on CostManager which defines the cost function and the use of heuristics
// The algorithm optimizes the route in terms of travel time or number of transfers, depending on the user's choice
fn (g Graph) knox(start_id int, stops []string, cost_manager CostManager, cost_selector CostSelector) ([][]Edge, int, int, time.Duration, []string) {
	max_iterations := int(graph.iterations_multiplier * math.pow(stops.len, 2))
	iterations_threshold := int(graph.threshold_multiplier * math.sqrt(max_iterations))
	aspiration := g.calculate_aspiration(start_id, stops, cost_manager, cost_selector)

	mut turns_since_improvement := 0
	mut tabu_list := []Tabu{}
	mut current_solution := stops.clone()
	rand.shuffle(mut current_solution) or {}
	mut current_solution_cost := g.calculate_tabu_cost(start_id, current_solution, cost_manager,
		cost_selector)

	mut best_solution := current_solution.clone()
	mut best_solution_cost := current_solution_cost

	timer := time.now()
	for _ in 0 .. stops.len {
		if turns_since_improvement > iterations_threshold {
			break
		}

		mut best_neighbour := current_solution.clone()
		mut best_neighbour_cost := current_solution_cost
		mut tabu_candidate := Tabu{0, 0}

		for i in 0 .. stops.len {
			for j in i + 1 .. stops.len {
				if rand.f32() > 0.2 {
					continue
				}

				neighbour := swap_elements(i, j, current_solution)
				neighbour_cost := g.calculate_tabu_cost(start_id, neighbour, cost_manager,
					cost_selector)

				tabu := Tabu{i, j}
				if (tabu !in tabu_list || neighbour_cost < aspiration)
					&& neighbour_cost < best_neighbour_cost { // aspiration criteria
					best_neighbour = neighbour.clone()
					best_neighbour_cost = neighbour_cost
					tabu_candidate = tabu
				}
			}
		}

		current_solution = best_neighbour.clone()
		current_solution_cost = best_neighbour_cost

		if tabu_list.len >= stops.len {
			tabu_list.delete(0)
		}
		tabu_list << tabu_candidate

		if best_neighbour_cost < best_solution_cost {
			best_solution = best_neighbour.clone()
			best_solution_cost = best_neighbour_cost
			turns_since_improvement = 0
		} else {
			turns_since_improvement += 1
		}
	}

	runtime := time.now() - timer
	path, travel_time, transfers := g.reconstruct_tabu_path(start_id, best_solution, cost_manager)
	return path, travel_time, transfers, runtime, best_solution
}

fn (g Graph) calculate_aspiration(start_id int, stops []string, cost_manager CostManager, cost_selector CostSelector) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]
	mut total := 0
	start_time := g.nodes[start_id].time.str()

	for start_stop in stops_complete {
		for end in stops_complete {
			start := g.find_nearest_node(start_stop, start_time)
			_, travel_time, transfers, _ := g.find_path(start, end, cost_manager)

			total += match cost_selector {
				.t {
					travel_time
				}
				.p {
					transfers
				}
			}
		}
	}

	return total / int(math.pow(stops_complete.len, 2))
}

fn (g Graph) calculate_tabu_cost(start_id int, stops []string, cost_manager CostManager, cost_selector CostSelector) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]
	mut total := 0
	mut previuos := Edge(EdgeWait{
		start: -1
		end: start_id
	})

	for stop in stops_complete {
		path, travel_time, transfers, _ := g.find_continuity_path(previuos, stop, cost_manager)
		previuos = path.last()
		total += match cost_selector {
			.t {
				travel_time
			}
			.p {
				transfers
			}
		}
	}

	return total
}

fn (g Graph) reconstruct_tabu_path(start_id int, stops []string, cost_manager CostManager) ([][]Edge, int, int) {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]
	mut full_path := [][]Edge{}
	mut total_travel_time := 0
	mut total_transfers := 0
	mut previuos := Edge(EdgeWait{
		start: -1
		end: start_id
	})

	for stop in stops_complete {
		path, travel_time, transfers, _ := g.find_continuity_path(previuos, stop, cost_manager)
		previuos = path.last()
		total_travel_time += travel_time
		total_transfers += transfers
		full_path << path
	}

	return full_path, total_travel_time, total_transfers
}
