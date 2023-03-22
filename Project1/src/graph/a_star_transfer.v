module graph

import time
// import simple_time
import datatypes { MinHeap }
import arrays
import term

pub fn a_star_transfer(start string, end string, start_t string, g Graph) {
	node_id := find_nearest_node(start, start_t, g)
	path, cost, calc_t := a_star_transfer_alg(node_id, end, g)
	simple_path := simplify_path(path)
	// print_path(path.reverse(), g)
	// println('-------------')
	println('A* transfer --- ${start} --> ${end}')
	print_path(simple_path, g)
	word := if cost == 1 {'transfer'} else{'transfers'}
	eprintln(term.gray('Cost: ${cost} ${word}'))
	eprintln(term.gray('Runtime: ${calc_t}'))
}

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
				curr_edge := travel_history[item.node] or {EdgeWait{0, 0}}
				match curr_edge {
					EdgeRide{
						match edge {
							EdgeRide{
								if curr_edge.line == edge.line {
									0
								} else {
									1
								}
							}
							else{1}
						}
					}
					else{0}
				}
			}

			next_cost := costs[item.node] + transfer
			if edge.end !in costs || next_cost < costs[edge.end] {
				priority := next_cost * 8 + transfer_heuristic_1(edge.start, possible_end_nodes, g)
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

fn disabled_heuristic(curr int, ends []int, g Graph) int {
	return 0
}

fn transfer_heuristic_1(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) / travel_speed)
	}
	return arrays.min(distances) or { 0 }
}

fn transfer_heuristic_2(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) * 20)
	}
	return arrays.min(distances) or { 0 }
}
