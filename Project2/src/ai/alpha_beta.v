module ai

import reversi
import time
import math

struct AlphaBeta {
mut:
	alpha f64
	beta  f64
}

fn (mut ab AlphaBeta) update(turn reversi.Player, max_player reversi.Player, score f64) {
	if turn == max_player {
		ab.alpha = math.max(ab.alpha, score)
	} else {
		ab.beta = math.min(ab.beta, score)
	}
}

fn (ab AlphaBeta) should_skip() bool {
	return ab.beta <= ab.alpha
}

pub fn find_move_alpha_beta(game reversi.Reversi, heuristic Heuristic, max_depth int) (reversi.Move, time.Duration, int) {
	mut m := SearchHelper{heuristic, game.turn(), 0}
	mut ab := AlphaBeta{math.inf(-1), math.inf(1)}
	timer := time.now()
	_, move := alpha_beta(mut m, game, max_depth, Action.max, mut ab)
	return move, time.now() - timer, m.visited_branch
}

fn alpha_beta(mut sh SearchHelper, game reversi.Reversi, depth int, action Action, mut ab AlphaBeta) (f64, reversi.Move) {
	sh.increment_visited()

	if game.is_game_over() {
		return evaluate_game_over(game, sh.player), reversi.Move{}
	}

	if depth == 0 {
		return sh.heuristic.evaluate(game, sh.player), reversi.Move{}
	}

	if !game.can_move() {
		return alpha_beta(mut sh, game.skip_turn(), depth - 1, action.opposite(), mut
			ab)
	}

	mut available_moves := game.potential_moves_list()
	mut best_move := available_moves.pop()
	mut best_score, _ := alpha_beta(mut sh, game.make_move(best_move), depth - 1, action.opposite(), mut
		ab)

	for move in available_moves {
		score, _ := alpha_beta(mut sh, game.make_move(move), depth - 1, action.opposite(), mut
			ab)

		if better_score(best_score, score, action) {
			best_score = score
			best_move = move
		}

		// Alpha-beta pruning
		ab.update(game.turn(), sh.player, score)
		if ab.should_skip() {
			break
		}
	}

	return best_score, best_move
}
