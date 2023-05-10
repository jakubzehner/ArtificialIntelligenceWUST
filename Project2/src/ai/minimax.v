module ai

import reversi
import time

struct Minimax {
	heuristic Heuristic
	player    reversi.Player
mut:
	visited_branch int
}

pub fn find_move(game reversi.Reversi, heuristic Heuristic, max_depth int) (reversi.Move, time.Duration, int) {
	mut m := Minimax{heuristic, game.turn(), 0}
	timer := time.now()
	_, move := minimax(mut m, game, max_depth, Action.max)
	return move, time.now() - timer, m.visited_branch
}

fn minimax(mut m Minimax, game reversi.Reversi, depth int, action Action) (f64, reversi.Move) {
	m.visited_branch += 1

	if game.is_game_over() {
		return evaluate_game_over(game, m.player), reversi.Move{}
	}

	if depth == 0 {
		return m.heuristic.evaluate(game, m.player), reversi.Move{}
	}

	if !game.can_move() {
		return minimax(mut m, game.skip_turn(), depth - 1, action.opposite())
	}

	mut available_moves := game.potential_moves_list()
	mut best_move := available_moves.pop()
	mut best_score, _ := minimax(mut m, game.make_move(best_move), depth - 1, action.opposite())

	for move in available_moves {
		score, _ := minimax(mut m, game.make_move(move), depth - 1, action.opposite())

		if better_score(best_score, score, action) {
			best_score = score
			best_move = move
		}
	}

	return best_score, best_move
}
