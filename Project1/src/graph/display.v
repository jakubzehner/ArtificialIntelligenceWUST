module graph

import term

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
				println('${'⌛':1} | ${'':3} | ${term.bright_yellow(start_time)} - ${term.bright_yellow(end_time)} | ${term.bright_yellow(g.pos_to_name[node_start.pos.short_str()])}') // ${term.bold('-->')} ${term.bright_yellow(g.pos_to_name[node_end.pos.short_str()])}')
			}
			EdgeWalk {
				println('${'🚶':1} | ${'':3} | ${term.bright_yellow(start_time)} - ${term.bright_yellow(end_time)} | ${term.bright_yellow(g.pos_to_name[node_start.pos.short_str()])}') // ${term.bold('-->')} ${term.bright_yellow(g.pos_to_name[node_end.pos.short_str()])}')
			}
		}
	}
}

fn simplify_path(path []Edge) []Edge {
	if path.len <= 1 {
		return path
	}

	mut result := []Edge{}
	temp := path.last()
	mut start := temp.start
	mut end := temp.end
	mut line := if temp is EdgeRide { temp.line } else { '' }
	mut last := if temp is EdgeRide {
		'EdgeRide'
	} else {
		if temp is EdgeWalk { 'EdgeWalk' } else { 'EdgeWait' }
	}
	mut walk := false

	for i := path.len - 2; i >= 0; i -= 1 {
		edge := path[i]
		match edge {
			EdgeRide {
				if last == 'EdgeWalk' || (last == 'EdgeWait' && walk) {
					if start == end {
						result << EdgeWait{
							start: start
							end: end
						}
					} else {
						result << EdgeWalk{
							start: start
							end: end
						}
					}
					start = edge.start
					last = 'EdgeRide'
					line = edge.line
				} else if last == 'EdgeWait' && !walk {
					result << EdgeWait{
						start: start
						end: end
					}
					start = edge.start
					last = 'EdgeRide'
					line = edge.line
				} else if line != edge.line {
					result << EdgeRide{
						start: start
						end: end
						line: line
					}
					start = edge.start
					last = 'EdgeRide'
					line = edge.line
				}
				end = edge.end
				walk = false
			}
			EdgeWait {
				if last == 'EdgeRide' {
					result << EdgeRide{
						start: start
						end: end
						line: line
					}
					start = edge.start
					last = 'EdgeWait'
					line = ''
				}
				end = edge.end
			}
			EdgeWalk {
				if last == 'EdgeRide' {
					result << EdgeRide{
						start: start
						end: end
						line: line
					}
					start = edge.start
					last = 'EdgeWalk'
					line = ''
				}
				end = edge.end
				walk = true
			}
		}
	}

	match last {
		'EdgeRide' {
			result << EdgeRide{
				start: start
				end: end
				line: line
			}
		}
		else {
			eprintln('The last element of the path other than the Ride was unexpected')
		}
	}

	return result
}
