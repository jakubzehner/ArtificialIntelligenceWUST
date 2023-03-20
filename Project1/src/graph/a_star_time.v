module graph

import time
import simple_time { SimpleTime }
import datatypes { MinHeap }
import arrays

pub fn a_star_time(start string, end string, start_t string, g Graph) {
	node_id := find_nearest_node(start, start_t, g)
	path, cost, calc_t := a_star_time_alg(node_id, end, g)
	simple_path := simplify_path(path)
	// print_path(path.reverse(), g)
	// println('-------------')
	print_path(simple_path, g)
	travel_time := SimpleTime{u16(cost)}
	println('Travel time: ${travel_time.time_str()} (${travel_time.minutes()} min)')
	eprintln('Runtime: ${calc_t}')
}

fn a_star_time_alg(start int, end string, g Graph) ([]Edge, int, time.Duration) {
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
			start_node := g.nodes[edge.start]
			end_node := g.nodes[edge.end]
			travel_cost := (end_node.time - start_node.time).minutes()

			next_cost := costs[item.node] + travel_cost
			if edge.end !in costs || next_cost < costs[edge.end] {
				priority := next_cost + heuristic_2(edge.start, possible_end_nodes, g)
				costs[edge.end] = next_cost
				travel_history[edge.end] = edge
				queue.insert(HeapItem{ cost: priority, node: edge.end })
			}
		}
	}

	runtime := time.now() - a_star_start_time

	final_cost := costs[destination]

	mut path := []Edge{}

	for {
		if destination == start {
			break
		}
		edge := travel_history[destination] or { break }
		path << edge
		destination = edge.start
	}

	return path, final_cost, runtime
}

fn heuristic_1(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) / travel_speed)
	}
	return arrays.min(distances) or {0}
}

fn heuristic_2(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) * 10)
	}
	return arrays.min(distances) or {0}
}
