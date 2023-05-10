module ai

import reversi

struct SearchHelper {
	heuristic Heuristic
	player    reversi.Player
mut:
	visited_branch int
}

fn (mut sh SearchHelper) increment_visited() {
	sh.visited_branch += 1
}
