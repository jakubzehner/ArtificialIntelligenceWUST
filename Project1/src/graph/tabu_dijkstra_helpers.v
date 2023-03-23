module graph

import datatypes { MinHeap }

fn dijkstra_time_tabu(start int, end string, g Graph) ([]Edge, int, int) {
	mut costs := map[int]int{}
	mut travel_history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	mut destination := -1

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

	final_cost := costs[destination]
	path := reconstruct_path(start, destination, travel_history)

	return path, final_cost, destination
}


fn dijkstra_transfer_tabu(start int, end string, g Graph, last_travel Edge) ([]Edge, int, int) {
	mut costs := map[int]int{}
	mut travel_history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	mut destination := -1

	travel_history[start] = last_travel
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
			transfer := if current.node !in travel_history {
				0
			} else {
				is_transfer(travel_history[current.node] or { EdgeWait{0, 0} }, next_edge)
			}

			next_cost := current.cost + transfer
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
	travel_history.delete(start)

	final_cost := costs[destination]
	path := reconstruct_path(start, destination, travel_history)

	return path, final_cost, destination
}
