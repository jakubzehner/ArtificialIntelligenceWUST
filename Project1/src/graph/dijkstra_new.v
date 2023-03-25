module graph

import datatypes { MinHeap }
import time

pub fn dijkstra_test(g Graph) {
	cost_fn := fn (last Edge, next Edge, g Graph) int {
		if last == next {
			return 0
		}
		return (g.nodes[next.end].time - g.nodes[last.end].time).minutes()
	}
	path, cost, _ := g.dijkstra_impl(264198, 'Lubiatów', cost_fn, fn (last Edge, next Edge, g Graph) int {
		return 0
	})
	print_path(simplify_path(path), g)
	println(cost)
}

// Dijkstra algorithm implementation with any cost function
// Why not with generic cost function? It is currently bugged in V, it is not possible to implement such thing :c
fn (g Graph) dijkstra_impl(start_id int, end_name string, main_cost_function fn (Edge, Edge, Graph) int, secondary_cost_function fn (Edge, Edge, Graph) int) ?([]Edge, int, int) {
	return g.dijkstra_continuity_impl(EdgeWait{-1, start_id}, end_name, main_cost_function,
		secondary_cost_function) or { none }
}

// This implementation supports maintaining continuity between successive runs of the algorithm
// by passing the last Edge as the starting point.
fn (g Graph) dijkstra_continuity_impl(last_edge Edge, end_name string, main_cost_function fn (Edge, Edge, Graph) int, secondary_cost_function fn (Edge, Edge, Graph) int) ?([]Edge, int, int) {
	mut main_costs := map[int]int{}
	mut total_costs := map[int]int{}
	mut history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	main_costs[last_edge.end] = 0
	total_costs[last_edge.end] = 0
	history[last_edge.end] = last_edge
	queue.insert(HeapItem{ cost: 0, node_id: last_edge.end })

	timer := time.now()
	for queue.len() > 0 {
		curr := queue.pop() or { break }

		if reached_destination(curr.node_id, end_name, g) {
			history.delete(last_edge.end)
			path := reconstruct_path(last_edge.end, curr.node_id, history)
			cost := main_costs[curr.node_id]
			runtime := time.now() - timer

			return path, cost, runtime
		}

		if curr.node_id in total_costs && curr.cost > total_costs[curr.node_id] {
			continue
		}

		curr_edge := history[curr.node_id] or { break }
		for next_edge in g.edges[curr.node_id] {
			next_main_cost := main_costs[curr.node_id] + main_cost_function(curr_edge, next_edge, g)
			next_total_cost := curr.cost + main_cost_function(curr_edge, next_edge, g) +
				secondary_cost_function(curr_edge, next_edge, g)

			if next_edge.end !in total_costs || next_total_cost < total_costs[next_edge.end] {
				main_costs[next_edge.end] = next_main_cost
				total_costs[next_edge.end] = next_total_cost
				history[next_edge.end] = next_edge
				queue.insert(HeapItem{ cost: next_total_cost, node_id: next_edge.end })
			}
		}
	}

	eprintln('Could not find path!')
	return none
}
