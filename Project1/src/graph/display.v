module graph

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
				node_start := g.nodes[edge.start]
				node_end := g.nodes[edge.end]

				println('${'🚶':1} | ${'':3} | ${node_start.time} - ${node_end.time} | ${g.pos_to_name[node_start.pos.short_str()]} -> ${g.pos_to_name[node_end.pos.short_str()]}')
			}
		}
	}
}

fn simplify_path(path []Edge) []Edge {
	mut result := []Edge{}
	mut start := path.last().start
	mut end := path.last().end
	temp := path.last()
	mut line := if temp is EdgeRide { temp.line } else { '' }
	mut last := if temp is EdgeRide {'EdgeRide'} else {if temp is EdgeWalk {'EdgeWalk'} else {'EdgeWait'}}

	for i := path.len - 2; i >= 0; i -= 1 {
		edge := path[i]
		match edge {
			EdgeRide {
				if last == 'EdgeWait' {
					result << EdgeWait{
						start: start
						end: end
					}
					start = edge.start
					last = 'EdgeRide'
					line = edge.line
				} else if last == 'EdgeWalk' {
					result << EdgeWalk{
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
				} else if last == 'EdgeWalk' {
					result << EdgeWalk{
						start: start
						end: end
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
				} else if last == 'EdgeWait' {
					result << EdgeWait{
						start: start
						end: end
					}
					start = edge.start
					last = 'EdgeWalk'
					line = ''
				}
				end = edge.end
			}
		}
	}

	match last {
		'EdgeWalk' {
			result << EdgeWalk{
				start: start
				end: end
			}
		}
		'EdgeWait' {
			result << EdgeWait{
				start: start
				end: end
			}
		}
		'EdgeRide' {
			result << EdgeRide{
				start: start
				end: end
				line: line
			}
		}
		else {}
	}

	return result
}
