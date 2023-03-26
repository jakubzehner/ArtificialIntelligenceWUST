module graph

import datatypes { MinHeap }
import time

struct CostManager {
	use_heuristic bool
	heuristic     fn (int, []int, Graph) f64
	cost_function fn (Edge, Edge, Graph) f64
}

struct NodePriority {
	id       int
	priority f64
}

// Path finding algorithm implementation
// Behaviour depends on CostManager which defines the cost function and the use of heuristics
fn (g Graph) find_path(start_id int, end_name string, cost_manager CostManager) ?([]Edge, int, int, time.Duration) {
	return g.find_continuity_path(EdgeWait{-1, start_id}, end_name, cost_manager) or { none }
}

// Path finding algorithm implementation
// Behaviour depends on CostManager which defines the cost function and the use of heuristics
// This implementation supports maintaining continuity between successive runs of the algorithm
// by passing the last Edge as the starting point.
fn (g Graph) find_continuity_path(prev_edge Edge, end_name string, cost_manager CostManager) ?([]Edge, int, int, time.Duration) {
	mut travel_times := map[int]int{}
	mut transfers := map[int]int{}
	mut costs := map[int]f64{}
	mut history := map[int]Edge{}
	mut queue := MinHeap[NodePriority]{}

	start_id := prev_edge.end
	possible_end_ids := g.name_to_nodes_ids[end_name]

	travel_times[start_id] = 0
	transfers[start_id] = 0
	costs[start_id] = 0.0
	history[start_id] = prev_edge

	queue.insert(NodePriority{ id: start_id, priority: 0.0 })
	timer := time.now()
	for queue.len() > 0 {
		curr := queue.pop() or { break }

		if g.reached_destination(curr.id, end_name) {
			history.delete(start_id)
			path := reconstruct_path(start_id, curr.id, history)
			travel_time := travel_times[curr.id]
			transfer := transfers[curr.id]
			runtime := time.now() - timer

			return path, travel_time, transfer, runtime
		}

		if !cost_manager.use_heuristic && curr.id in costs && curr.priority > costs[curr.id] {
			continue
		}

		curr_edge := history[curr.id] or { break }
		for next_edge in g.edges[curr.id] {
			next_cost := costs[curr.id] + cost_manager.cost_function(curr_edge, next_edge, g)

			if next_edge.end !in costs || next_cost < costs[next_edge.end] {
				priority := if cost_manager.use_heuristic {
					next_cost + cost_manager.heuristic(next_edge.start, possible_end_ids, g)
				} else {
					next_cost
				}

				costs[next_edge.end] = next_cost
				transfers[next_edge.end] = transfers[curr.id] +
					transfer_if_detected(curr_edge, next_edge)
				travel_times[next_edge.end] = travel_times[curr.id] +
					calculate_travel_time(g.nodes[curr.id], g.nodes[next_edge.end])
				history[next_edge.end] = next_edge
				queue.insert(NodePriority{ id: next_edge.end, priority: priority })
			}
		}
	}

	println('Could not find path!')
	return none
}

fn (node NodePriority) < (other NodePriority) bool {
	return node.priority < other.priority
}

fn (node NodePriority) == (other NodePriority) bool {
	return node.priority == other.priority
}
