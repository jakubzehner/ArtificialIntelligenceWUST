module ai

import reversi
import math
import rand

fn better_score(best_score f64, score f64, action Action) bool {
	return match action {
		.min {
			score < best_score
		}
		.max {
			score > best_score
		}
	}
}

fn evaluate_game_over(game reversi.Reversi, player reversi.Player) f64 {
	result := game.result()

	if result == .draw {
		return 0
	}

	return if (result == .white_winner && player == .white)
		|| (result == .black_winner && player == .black) {
		math.inf(1)
	} else {
		math.inf(-1)
	}
}

fn game_after_5_random_moves() reversi.Reversi {
	mut rev := reversi.clean_start()
	for _ in 0 .. 5 {
		moves := rev.potential_moves_list()
		move := rand.choose(moves, 1) or { moves }
		rev = rev.make_move(move[0])
	}
	return rev
}
