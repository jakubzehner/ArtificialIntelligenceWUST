module graph

import time
import math
import rand
import simple_time { SimpleTime }

const iterations_multiplier = 1.1

const threshold_multiplier = u64(2)

struct Tabu {
	x int
	y int
}

fn swap_elements(i int, j int, solution []string) []string {
	mut result := solution.clone()
	result[i], result[j] = result[j], result[i]
	return result
}

fn tabu_search_time_alg(start int, stops []string, g Graph) ([][]Edge, int, time.Duration, []string) {
	max_iterations := u64(math.ceil(graph.iterations_multiplier * (math.pow(stops.len,
		2))))
	improve_threshold := graph.threshold_multiplier * u64(math.floor(math.sqrt(max_iterations)))
	aspiration := calculate_aspiration_time(start, stops, g)

	mut turns_since_improvement := 0
	mut tabu_list := []Tabu{}

	mut current_solution := stops.clone()
	rand.shuffle(mut current_solution) or {}
	mut current_solution_cost := calculate_cost(start, current_solution, g)

	mut best_solution := current_solution.clone()
	mut best_solution_cost := current_solution_cost

	tabu_start_time := time.now()

	for _ in 0 .. max_iterations {
		if turns_since_improvement > improve_threshold {
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
				neighbour_cost := calculate_cost(start, neighbour, g)

				tabu := Tabu{i, j}
				if (tabu !in tabu_list || neighbour_cost < aspiration) && neighbour_cost < best_neighbour_cost {
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

		// eprintln('Iteration: ${iter} cost: ${best_solution_cost}')
	}

	runtime := time.now() - tabu_start_time
	path := reconstruct_tabu_path(start, best_solution, g)
	return path, best_solution_cost, runtime, best_solution
}

fn calculate_cost(start_id int, stops []string, g Graph) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]

	mut prev := start_id
	mut total_cost := 0

	for stop in stops_complete {
		_, cost, next := dijkstra_time_tabu(prev, stop, g)
		prev = next
		total_cost += cost
	}

	return total_cost
}

fn reconstruct_tabu_path(start_id int, stops []string, g Graph) [][]Edge {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]

	mut prev := start_id
	mut total := [][]Edge{}

	for stop in stops_complete {
		path, _, next := dijkstra_time_tabu(prev, stop, g)
		prev = next
		total << path
	}

	return total
}

///////////////

fn tabu_search_transfer_alg(start int, stops []string, g Graph) ([][]Edge, int, time.Duration, []string) {
	max_iterations := u64(math.ceil(graph.iterations_multiplier * (math.pow(stops.len,
		2))))
	improve_threshold := graph.threshold_multiplier * u64(math.floor(math.sqrt(max_iterations)))
	aspiration := calculate_aspiration_transfer(start, stops, g)

	mut turns_since_improvement := 0
	mut tabu_list := []Tabu{}

	mut current_solution := stops.clone()
	rand.shuffle(mut current_solution) or {}
	mut current_solution_cost := calculate_cost_transfer(start, current_solution, g)

	mut best_solution := current_solution.clone()
	mut best_solution_cost := current_solution_cost

	tabu_start_time := time.now()

	for _ in 0 .. max_iterations {
		if turns_since_improvement > improve_threshold {
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
				neighbour_cost := calculate_cost_transfer(start, neighbour, g)

				tabu := Tabu{i, j}
				if (tabu !in tabu_list || neighbour_cost < aspiration) && neighbour_cost < best_neighbour_cost { // aspiration criteria
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

		// eprintln('Iteration: ${iter} cost: ${best_solution_cost}')
	}

	runtime := time.now() - tabu_start_time
	path := reconstruct_tabu_path_transfer(start, best_solution, g)
	return path, best_solution_cost, runtime, best_solution
}

fn calculate_cost_transfer(start_id int, stops []string, g Graph) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]

	mut prev := start_id
	mut total_cost := 0
	mut last_travel := Edge(EdgeWait{0, 0})

	for stop in stops_complete {
		path, cost, next := dijkstra_transfer_tabu(prev, stop, g, last_travel)
		prev = next
		total_cost += cost
		last_travel = path[0]
	}

	return total_cost
}

fn reconstruct_tabu_path_transfer(start_id int, stops []string, g Graph) [][]Edge {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start_id].pos.short_str()]

	mut prev := start_id
	mut total := [][]Edge{}
	mut last_travel := Edge(EdgeWait{0, 0})

	for stop in stops_complete {
		path, _, next := dijkstra_transfer_tabu(prev, stop, g, last_travel)
		prev = next
		total << path
		last_travel = path[0]
	}

	return total
}

fn calculate_aspiration_time(start int, stops []string, g Graph) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start].pos.short_str()]
	mut total := 0
	start_time := g.nodes[start].time.str()

	for i in 0..stops.len {
		for j in 0..stops.len {
			start_id := find_nearest_node(stops[i], start_time, g)
			_, cost, _ := dijkstra_time_tabu(start_id, stops[j], g)
			total += cost
		}
	}
	return total / (stops.len * stops.len)
}

fn calculate_aspiration_transfer(start int, stops []string, g Graph) int {
	mut stops_complete := stops.clone()
	stops_complete << g.pos_to_name[g.nodes[start].pos.short_str()]
	mut total := 0
	start_time := g.nodes[start].time.str()
	last_travel := Edge(EdgeWait{0, 0})

	for i in 0..stops.len {
		for j in 0..stops.len {
			start_id := find_nearest_node(stops[i], start_time, g)
			_, cost, _ := dijkstra_transfer_tabu(start_id, stops[j], g, last_travel)
			total += cost
		}
	}
	return total / (stops.len * stops.len)
}
