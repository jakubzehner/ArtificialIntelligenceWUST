module graph

import arrays
import position { Position }

const travel_speed = f64(20) / f64(60) // in km per minute

fn dummy_heuristic(_ int, _ []int, _ Graph) f64 {
	return 0.0
}

fn heuristic_distance(curr int, ends []int, g Graph) f64 {
	mut distances := []f64{}
	for end in ends {
		distances << g.nodes[curr].pos.distance_to(g.nodes[end].pos) / graph.travel_speed
	}
	return arrays.min(distances) or { 0.0 }
}

fn heuristic_manhattan_distance(curr int, ends []int, g Graph) f64 {
	mut distances := []f64{}
	for end in ends {
		distances << g.nodes[curr].pos.manhattan_distance_to(g.nodes[end].pos) / graph.travel_speed
	}
	return arrays.min(distances) or { 0.0 }
}

fn heuristic_center_distance(curr int, ends []int, g Graph) f64 {
	mut distances := []f64{}
	for end in ends {
		distances << g.nodes[curr].pos.distance_to(Position{0, 0}) / graph.travel_speed +
			g.nodes[end].pos.distance_to(Position{0, 0}) / graph.travel_speed
	}
	return arrays.min(distances) or { 0.0 }
}
