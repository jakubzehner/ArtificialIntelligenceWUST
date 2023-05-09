module graph

import simple_time { SimpleTime }

fn cost_name(cost CostSelector) string {
	return match cost {
		.t { 'time minimization' }
		.p { 'transfers minimization' }
	}
}

fn calculate_travel_time(from Node, to Node) int {
	return (to.time - from.time).minutes()
}

fn transfer_if_detected(from Edge, to Edge) int {
	return if detect_transfer(from, to) { 1 } else { 0 }
}

fn detect_transfer(from Edge, to Edge) bool {
	return (from is EdgeRide)
		&& (to !is EdgeRide || (from as EdgeRide).line != (to as EdgeRide).line)
}

fn swap_elements(i int, j int, solution []string) []string {
	mut result := solution.clone()
	result[i], result[j] = result[j], result[i]
	return result
}

fn reconstruct_path(start int, end int, history map[int]Edge) []Edge {
	mut path := []Edge{}
	mut node_id := end

	for {
		if node_id == start {
			break
		}
		edge := history[node_id] or { break }
		path << edge
		node_id = edge.start
	}

	return path.reverse()
}

fn (g Graph) check_if_name_exists(name string) bool {
	existence := name in g.name_to_nodes_ids
	if !existence {
		println('Stop: ${name} does not exist')
	}
	return existence
}

fn (g Graph) find_nearest_node(start string, start_time string) ?int {
	start_simple_time := simple_time.from(start_time)

	mut id := -1
	mut node_time := SimpleTime{1440}
	for node_id in g.name_to_nodes_ids[start] {
		node := g.nodes[node_id]
		if node.time < node_time && node.time >= start_simple_time {
			id = node_id
			node_time = node.time
		}
	}

	return if id != -1 {
		id
	} else {
		eprintln('Could not find node for ${start} later than ${start_time}')
		none
	}
}

fn (g Graph) reached_destination(node int, end string) bool {
	return g.pos_to_name[g.nodes[node].pos.short_str()] == end
}