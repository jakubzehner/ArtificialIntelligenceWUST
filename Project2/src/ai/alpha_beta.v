module ai

import reversi
import time
import math

pub fn find_move_alpha_beta(game reversi.Reversi, heuristic Heuristic, max_depth int) (reversi.Move, time.Duration, int) {
	mut m := SearchHelper{heuristic, game.turn(), 0}
	timer := time.now()
	_, move := alpha_beta(mut m, game, max_depth, Action.max, math.inf(-1), math.inf(1))
	return move, time.now() - timer, m.visited_branch
}

fn alpha_beta(mut sh SearchHelper, game reversi.Reversi, depth int, action Action, alpha f64, beta f64) (f64, reversi.Move) {
	sh.increment_visited()
	mut a, mut b := alpha, beta

	if game.is_game_over() {
		return evaluate_game_over(game, sh.player), reversi.Move{}
	}

	if depth == 0 {
		return sh.heuristic.evaluate(game, sh.player), reversi.Move{}
	}

	if !game.can_move() {
		return alpha_beta(mut sh, game.skip_turn(), depth - 1, action.opposite(), a, b)
	}

	mut available_moves := game.potential_moves_list()
	mut best_move := available_moves.pop()
	mut best_score, _ := alpha_beta(mut sh, game.make_move(best_move), depth - 1, action.opposite(),
		a, b)

	for move in available_moves {
		score, _ := alpha_beta(mut sh, game.make_move(move), depth - 1, action.opposite(),
			a, b)

		if better_score(best_score, score, action) {
			best_score = score
			best_move = move
		}

		// Alpha-beta pruning
		if game.turn() == sh.player {
			a = math.max(a, score)
		} else {
			b = math.min(b, score)
		}
		if b <= a {
			break
		}
	}

	return best_score, best_move
}
