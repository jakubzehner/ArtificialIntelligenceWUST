module graph

import math
import term
import time
import position { Position }
import simple_time { SimpleTime }
import utils

pub const walking_speed = f32(4) / f32(60) // in km per minute

pub fn build_graph(rows utils.Rows) Graph {
	mut pos_to_name := map[string]string{}
	mut name_to_nodes_ids := map[string][]int{}
	mut edges := [][]Edge{cap: 1_400_000}
	mut nodes := []Node{cap: 280_000}

	// temporary data to speed up calculations
	mut nodes_to_id := map[string]int{}
	mut name_to_pos := map[string][]Position{}
	mut times_of_pos := map[string][]SimpleTime{}

	mut id := 0
	next_id := fn [mut id] () int {
		defer {
			id += 1
		}
		return id
	}

	start_building_graph := time.now()

	for row in rows {
		start := Node{
			pos: row.start_pos
			time: row.start_time
		}
		end := Node{
			pos: row.end_pos
			time: row.end_time
		}
		start_str := start.short_str()
		end_str := end.short_str()
		start_pos_str := row.start_pos.short_str()
		end_pos_str := row.end_pos.short_str()

		if start_str !in nodes_to_id {
			node_id := next_id()
			nodes_to_id[start_str] = node_id
			name_to_nodes_ids[row.start_stop] << node_id
			nodes << start
			edges << []Edge{}
		}
		if end_str !in nodes_to_id {
			node_id := next_id()
			nodes_to_id[end_str] = node_id
			name_to_nodes_ids[row.end_stop] << node_id
			nodes << end
			edges << []Edge{}
		}

		if start_pos_str !in pos_to_name {
			pos_to_name[start_pos_str] = row.start_stop
			name_to_pos[row.start_stop] << row.start_pos
		}
		if end_pos_str !in pos_to_name {
			pos_to_name[end_pos_str] = row.end_stop
			name_to_pos[row.end_stop] << row.end_pos
		}

		times_of_pos[start_pos_str] << row.start_time
		times_of_pos[end_pos_str] << row.end_time

		edge := EdgeRide{
			start: nodes_to_id[start_str]
			end: nodes_to_id[end_str]
			line: row.line
		}

		node_id := nodes_to_id[start_str]
		edges[node_id] << edge
	}

	// walking v2
	for node_id in 0 .. nodes.len {
		start := nodes[node_id]
		other_positions := name_to_pos[pos_to_name[start.pos.short_str()]]
		for other in other_positions {
			if other == start.pos {
				continue
			}

			next_time := start.find_next_other_position(other, times_of_pos)
			end := Node{
				pos: other
				time: next_time
			}
			end_node_id := nodes_to_id[end.short_str()]
			edge := EdgeWalk{
				start: node_id
				end: end_node_id
			}

			edges[node_id] << edge
		}
	}

	// waiting
	for node_id in 0 .. nodes.len {
		start := nodes[node_id]
		next_time := start.find_next(times_of_pos) or { continue }

		end := Node{
			pos: start.pos
			time: next_time
		}
		end_node_id := nodes_to_id[end.short_str()]

		edge := EdgeWait{
			start: node_id
			end: end_node_id
		}

		edges[node_id] << edge
	}

	println(term.gray('Building graph time: ${time.now() - start_building_graph}'))

	return Graph{pos_to_name, name_to_nodes_ids, edges, nodes}
}

fn (node Node) find_next(times map[string][]SimpleTime) ?SimpleTime {
	mut min := SimpleTime{1440}
	mut next := SimpleTime{1440}

	for time in times[node.pos.short_str()] {
		if time < min {
			min = time
		}
		if time < next && time > node.time {
			next = time
		}
	}
	t_next := if next == SimpleTime{1440} { min } else { next }
	if node.time == t_next {
		return none
	}
	// println('obecny czas: ${node.time}, nastepny: ${t_next}')
	return t_next
}

fn (node Node) find_next_other_position(pos Position, times map[string][]SimpleTime) SimpleTime {
	mut min := SimpleTime{1440}
	mut next := SimpleTime{1440}

	walk_time := SimpleTime{u16(math.round(node.pos.distance_to(pos) / graph.walking_speed))}

	for time in times[pos.short_str()] {
		if time < min {
			min = time
		}
		if time < next && time > node.time + walk_time {
			next = time
		}
	}
	t_next := if next == SimpleTime{1440} { min } else { next }
	// println('obecny czas: ${node.time}, nastepny: ${t_next}')
	return t_next
}
