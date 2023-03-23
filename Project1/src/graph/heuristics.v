module graph

import arrays
import position { Position }

const travel_speed = f32(5) / f32(60) // in km per minute

fn used_heuristic(curr int, ends []int, g Graph) int {
	return heuristic_distance(curr, ends, g)
}

fn disabled_heuristic(curr int, ends []int, g Graph) int {
	return 0
}

fn heuristic_distance(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) / graph.travel_speed)
	}
	return arrays.min(distances) or { 0 }
}

fn heuristic_manhattan_distance(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.manhattan_distance_to(g.nodes[end].pos) / graph.travel_speed)
	}
	return arrays.min(distances) or { 0 }
}

fn heuristic_center_distance(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(Position{0, 0}) / graph.travel_speed +
			g.nodes[end].pos.distance_to(Position{0, 0}) / graph.travel_speed)
	}
	return arrays.min(distances) or { 0 }
}
