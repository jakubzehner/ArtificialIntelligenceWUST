module graph

import time
import datatypes { MinHeap }

fn a_star_transfer_alg(start int, end string, g Graph) ([]Edge, int, time.Duration) {
	mut costs := map[int]int{}
	mut travel_history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	mut destination := -1

	possible_end_nodes := g.name_to_nodes_ids[end]

	a_star_start_time := time.now()

	costs[start] = 0
	queue.insert(HeapItem{ cost: 0, node_id: start })

	for queue.len() != 0 {
		item := queue.pop() or { break }

		if reached_destination(item.node_id, end, g) {
			destination = item.node_id
			break
		}

		for edge in g.edges[item.node_id] {
			curr_edge := travel_history[item.node_id] or { dummy_edge }
			transfer := transfer_if_detected(curr_edge, edge)

			next_cost := costs[item.node_id] + transfer * 3600
			if edge.end !in costs || next_cost < costs[edge.end] {
				priority := next_cost + used_heuristic(edge.start, possible_end_nodes, g)
				costs[edge.end] = next_cost
				travel_history[edge.end] = edge
				queue.insert(HeapItem{ cost: priority, node_id: edge.end })
			}
		}
	}

	runtime := time.now() - a_star_start_time
	final_cost := costs[destination]
	path := reconstruct_path(start, destination, travel_history)

	return path, final_cost, runtime
}
