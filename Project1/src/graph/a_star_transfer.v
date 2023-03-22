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
	queue.insert(HeapItem{ cost: 0, node: start })

	for queue.len() != 0 {
		item := queue.pop() or { break }

		if reached_destination(item.node, end, g) {
			destination = item.node
			break
		}

		for edge in g.edges[item.node] {
			transfer := if item.node !in travel_history {
				0
			} else {
				is_transfer(travel_history[item.node] or { EdgeWait{0, 0} }, edge)
			}

			next_cost := costs[item.node] + transfer
			if edge.end !in costs || next_cost < costs[edge.end] {
				priority := next_cost * 10 + transfer_heuristic_1(edge.start, possible_end_nodes, g)
				costs[edge.end] = next_cost
				travel_history[edge.end] = edge
				queue.insert(HeapItem{ cost: priority, node: edge.end })
			}
		}
	}

	runtime := time.now() - a_star_start_time
	final_cost := costs[destination]
	path := reconstruct_path(start, destination, travel_history)

	return path, final_cost, runtime
}

fn is_transfer(last_edge Edge, curr_edge Edge) int {
	return match last_edge {
		EdgeRide {
			match curr_edge {
				EdgeRide {
					if curr_edge.line == curr_edge.line {
						0
					} else {
						1
					}
				}
				else {
					1
				}
			}
		}
		else {
			0
		}
	}
}
