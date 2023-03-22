module graph

import datatypes { MinHeap }
import time

fn dijkstra_alg(start int, end string, g Graph) ([]Edge, int, time.Duration) {
	mut costs := map[int]int{}
	mut travel_history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	mut destination := -1

	dijkstra_start_time := time.now()

	costs[start] = 0
	queue.insert(HeapItem{ cost: 0, node: start })

	for queue.len() != 0 {
		current := queue.pop() or { break }

		if reached_destination(current.node, end, g) {
			destination = current.node
			break
		}
		if (current.node in costs) && (current.cost > costs[current.node]) {
			continue
		}

		for next_edge in g.edges[current.node] {
			start_node := g.nodes[next_edge.start]
			end_node := g.nodes[next_edge.end]
			travel_cost := (end_node.time - start_node.time).minutes()

			next_cost := current.cost + travel_cost
			if next_edge.end !in costs || next_cost < costs[next_edge.end] {
				costs[next_edge.end] = next_cost
				travel_history[next_edge.end] = next_edge
				queue.insert(HeapItem{ cost: next_cost, node: next_edge.end })
			}
		}
	}

	if destination == -1 {
		panic('Could not find destination!')
	}

	runtime := time.now() - dijkstra_start_time
	final_cost := costs[destination]
	path := reconstruct_path(start, destination, travel_history)

	return path, final_cost, runtime
}
