module ai

import reversi
import math

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
