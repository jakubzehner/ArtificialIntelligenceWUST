module graph

import arrays
const travel_speed = f32(15) / f32(60) // in km per minute


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


fn heuristic_1(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) / travel_speed)
	}
	return arrays.min(distances) or {0}
}

fn heuristic_2(curr int, ends []int, g Graph) int {
	mut distances := []int{}
	for end in ends {
		distances << int(g.nodes[curr].pos.distance_to(g.nodes[end].pos) * 20)
	}
	return arrays.min(distances) or {0}
}
