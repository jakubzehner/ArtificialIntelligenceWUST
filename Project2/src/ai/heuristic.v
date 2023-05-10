module ai

import reversi

pub enum Heuristic {
	coin_parity
}

fn (heuristic Heuristic) evaluate(game reversi.Reversi, player reversi.Player) f64 {
	return match heuristic {
		.coin_parity { evaluate_coin_parity(game, player) }
	}
}

fn evaluate_coin_parity(game reversi.Reversi, player reversi.Player) f64 {
	white_score, black_score := game.points()
	max, min := match player {
		.white {
			white_score, black_score
		}
		.black {
			black_score, white_score
		}
	}

	return 100 * (max - min) / (max + min)
}
