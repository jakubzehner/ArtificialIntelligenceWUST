module graph

import term

fn (g Graph) show_path_result(path []Edge) {
	show_path_result(path, g)
}

fn show_path_result(path []Edge, g Graph) {
	simple_path := simplify_path(path)
	print_path(simple_path, g)
}

fn print_path(path []Edge, g Graph) {
	for edge in path {
		node_start := g.nodes[edge.start]
		node_end := g.nodes[edge.end]
		start_time := node_start.time.str()
		end_time := node_end.time.str()
		match edge {
			EdgeRide {
				println('${'🚌':1} | ${edge.line:3} | ${term.bright_green(start_time)} - ${term.bright_red(end_time)} | ${term.bright_green(g.pos_to_name[node_start.pos.short_str()])} --> ${term.bright_red(g.pos_to_name[node_end.pos.short_str()])}')
			}
			EdgeWait {
				println('${'⌛':1} | ${'':3} | ${term.bright_yellow(start_time)} - ${term.bright_yellow(end_time)} | ${term.bright_yellow(g.pos_to_name[node_start.pos.short_str()])}')
			}
			EdgeWalk {
				println('${'🚶':1} | ${'':3} | ${term.bright_yellow(start_time)} - ${term.bright_yellow(end_time)} | ${term.bright_yellow(g.pos_to_name[node_start.pos.short_str()])}')
			}
		}
	}
}

fn simplify_path(path []Edge) []Edge {
	if path.len <= 1 {
		return path
	}

	edge_to_type_id := fn (edge Edge) int {
		return match edge {
			EdgeRide { 0 }
			EdgeWait { 1 }
			EdgeWalk { 2 }
		}
	}
	first := path.first()

	mut result := []Edge{}
	mut start := first.start
	mut end := first.end
	mut line := if first is EdgeRide { first.line } else { '' }
	mut last := edge_to_type_id(first)
	mut walk := false

	for edge in path[1..] {
		if edge_to_type_id(edge) == 0 {
			if (last == 2 || (last == 1 && walk)) && start == end {
				result << EdgeWait{start, end}
			} else if last == 2 || (last == 1 && walk) {
				result << EdgeWalk{start, end}
			} else if last == 1 {
				result << EdgeWait{start, end}
			} else if line != (edge as EdgeRide).line {
				result << EdgeRide{start, end, line}
			}

			if last != edge_to_type_id(edge) || line != (edge as EdgeRide).line {
				start = edge.start
				line = (edge as EdgeRide).line
			}
			walk = false
		} else {
			if last == 0 {
				result << EdgeRide{start, end, line}
				start = edge.start
				line = ''
			} else if last == 2 {
				walk = true
			}
		}

		last = edge_to_type_id(edge)
		end = edge.end
	}

	if last != 0 {
		eprintln('The last element of the path other than the Ride was unexpected!')
	}

	result << EdgeRide{start, end, line}
	return result
}
