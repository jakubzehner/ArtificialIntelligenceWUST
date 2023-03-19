module graph

import utils
import time
import simple_time { SimpleTime }
import position { Position }
import math

	pub const walking_speed = f32(4) / f32(60) // in km per minute

pub struct Graph {
	pos_to_name       map[string]string
	name_to_nodes_ids map[string][]int
	edges             map[int][]Edge
	nodes             map[int]Node
}

pub fn build_graph(rows utils.Rows) Graph {
	mut pos_to_name := map[string]string{}
	mut name_to_nodes_ids := map[string][]int{}
	mut edges := map[int][]Edge{}
	mut nodes := map[int]Node{}

	// temporary data to speed up calculations
	mut nodes_to_id := map[string]int{}
	mut name_to_pos := map[string][]Position{}
	mut times_of_pos := map[string][]SimpleTime{}
	mut time_need_to_walk_cache := map[string]SimpleTime{}

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
			nodes[node_id] = start
		}
		if end_str !in nodes_to_id {
			node_id := next_id()
			nodes_to_id[end_str] = node_id
			name_to_nodes_ids[row.end_stop] << node_id
			nodes[node_id] = end
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

		edges[nodes_to_id[start_str]] << edge
	}

	// walking ???
	exist_nodes_ids := nodes.keys()
	for node_id in exist_nodes_ids {
		this_node := nodes[node_id]
		positions := name_to_pos[pos_to_name[this_node.pos.short_str()]]
		for pos in positions {
			if pos == this_node.pos {
				continue
			}

			walk_time := cached_walk_time(this_node.pos, pos, mut time_need_to_walk_cache)
			end_time := this_node.time + walk_time
			walk_node_id := next_id()
			walk_node := Node{
				pos: pos
				time: end_time
			}
			walk_edge := EdgeWalk{
				start: node_id
				end: walk_node_id
			}

			nodes[walk_node_id] = walk_node
			edges[node_id] << walk_edge
			name_to_nodes_ids[pos_to_name[pos.short_str()]] << walk_node_id
			nodes_to_id[walk_node.short_str()] = walk_node_id
			times_of_pos[pos.short_str()] << end_time
		}
	}

	// waiting
	for node_id in nodes.keys() {
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

	println('Building graph time: ${time.now() - start_building_graph}')

	return Graph{pos_to_name, name_to_nodes_ids, edges, nodes}
}

fn cached_walk_time(this_pos Position, walk_pos Position, mut cache map[string]SimpleTime) SimpleTime {
	cache_key := '${this_pos};${walk_pos}'
	if cache_key in cache {
		return cache[cache_key]
	}

	dist := this_pos.distance_to(walk_pos)
	walk_minutes := dist / walking_speed
	walk_time := SimpleTime{u16(math.round(walk_minutes))}

	cache_key_alt := '${walk_pos};${this_pos}'
	cache[cache_key] = walk_time
	cache[cache_key_alt] = walk_time

	return walk_time
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

pub fn (graph Graph) stats() {
	mut edges_n := 0
	for node_id in graph.edges.keys() {
		edges_n += graph.edges[node_id].len
	}
	println('Nodes: ${graph.nodes.keys().len}')
	println('Edges: ${edges_n}')
}
