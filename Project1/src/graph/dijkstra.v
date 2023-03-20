module graph

import simple_time
import datatypes { MinHeap }
import time

struct HeapItem {
	cost int
	node int
}

fn (item1 HeapItem) < (item2 HeapItem) bool {
	return item1.cost < item2.cost
}

fn (item1 HeapItem) == (item2 HeapItem) bool {
	return item1.cost == item2.cost
}

pub fn dijkstra(start string, end string, start_t string, g Graph) {
	node_id := find_nearest_node(start, start_t, g)
	// println(node_id)
	// println(g.nodes[node_id])
	// println(g.pos_to_name[g.nodes[node_id].pos.short_str()])
	dijkstra_alg(node_id, end, g)
}

fn dijkstra_alg(start int, end string, g Graph) {
	mut costs := map[int]int{}
	mut travel_history := map[int]Edge{}
	mut queue := MinHeap[HeapItem]{}

	mut destination := -1

	dijkstra_start_time := time.now()

	costs[start] = 0
	queue.insert(HeapItem{ cost: 0, node: start })

	for queue.len() != 0 {
		item := queue.pop() or { break }

		if reached_destination(item.node, end, g) {
			destination = item.node
			break
		}
		if (item.node in costs) && (item.cost > costs[item.node]) {
			continue
		}

		for edge in g.edges[item.node] {
			start_node := g.nodes[edge.start]
			end_node := g.nodes[edge.end]
			travel_cost := (end_node.time - start_node.time).minutes()

			next_cost := item.cost + travel_cost
			if edge.end !in costs || next_cost < costs[edge.end] {
				costs[edge.end] = next_cost
				travel_history[edge.end] = edge
				queue.insert(HeapItem{ cost: next_cost, node: edge.end })
			}
		}
	}

	eprintln('Dijkstra time: ${time.now() - dijkstra_start_time}')

	println(destination)
	if destination != -1 {
		println(costs[destination])
	}

	mut path := []Edge{}

	for {
		if destination == start {
			break
		}
		edge := travel_history[destination] or {break}
		path << edge
		destination = edge.start
	}

	print_path(path.reverse(), g)
}

fn find_nearest_node(start string, start_t string, g Graph) int {
	t := simple_time.from(start_t)
	mut id := -1
	mut node_t := simple_time.SimpleTime{1440}
	for node_id in g.name_to_nodes_ids[start] {
		node := g.nodes[node_id]
		if node.time < node_t && node.time >= t {
			id = node_id
			node_t = node.time
		}
	}
	return id
}

fn reached_destination(node int, end string, g Graph) bool {
	return g.pos_to_name[g.nodes[node].pos.short_str()] == end
}

fn print_path(path []Edge, g Graph) {
	for edge in path {
		match edge {
			EdgeRide {
				node_start := g.nodes[edge.start]
				node_end := g.nodes[edge.end]

				println('${'🚌':1} | ${edge.line:3} | ${node_start.time} - ${node_end.time} | ${g.pos_to_name[node_start.pos.short_str()]} -> ${g.pos_to_name[node_end.pos.short_str()]}')
			}
			EdgeWait {
				node_start := g.nodes[edge.start]
				node_end := g.nodes[edge.end]

				println('${'⌛':1} | ${'':3} | ${node_start.time} - ${node_end.time} | ${g.pos_to_name[node_start.pos.short_str()]}')

			}
			EdgeWalk {

			}
		}
	}
}
