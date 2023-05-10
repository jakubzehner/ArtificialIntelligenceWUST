module ai

import reversi
import math.bits

const corners = u64(0x8100000000000081)

pub enum Heuristic {
	coin_parity
	corner_owned
	corner_closeness
	current_mobility
	potential_mobility
	stability
	korman
}

fn (heuristic Heuristic) evaluate(game reversi.Reversi, player reversi.Player) f64 {
	return match heuristic {
		.coin_parity { evaluate_coin_parity(game, player) }
		.corner_owned { evaluate_corner_owned(game, player) }
		.corner_closeness { evaluate_corner_closeness(game, player) }
		.current_mobility { evaluate_current_mobility(game, player) }
		.potential_mobility { evaluate_potential_mobility(game, player) }
		.stability { evaluate_stability(game, player) }
		.korman { evaluate_korman(game, player) }
	}
}

fn evaluate_coin_parity(game reversi.Reversi, player reversi.Player) f64 {
	white_score, black_score := game.points()

	max, min := get_max_min(white_score, black_score, player)

	return ratio(max, min)
}

fn evaluate_corner_owned(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	white_corners := f64(bits.ones_count_64(white_bitboard & ai.corners))
	black_corners := f64(bits.ones_count_64(black_bitboard & ai.corners))

	max, min := get_max_min(white_corners, black_corners, player)

	return (max - min) / 4.0
}

fn evaluate_corner_closeness(game reversi.Reversi, player reversi.Player) f64 {
	mut result := f64(0)
	for move in reversi.moves(ai.corners) {
		if reversi.has(game.board.empty(), move) {
			target := reversi.neighbours(reversi.move_to_bitboard(move))
			white_board, black_board := game.get_bitboards()
			white_sq := f64(bits.ones_count_64(target & white_board))
			black_sq := f64(bits.ones_count_64(target & black_board))

			max, min := get_max_min(white_sq, black_sq, player)
			result += -0.125 * (max - min)
		}
	}

	return result
}

fn evaluate_current_mobility(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	white_moves := bits.ones_count_64(reversi.potential_moves(white_bitboard, black_bitboard))
	black_moves := bits.ones_count_64(reversi.potential_moves(black_bitboard, white_bitboard))

	max, min := get_max_min(white_moves, black_moves, player)

	return ratio(max, min)
}

fn evaluate_potential_mobility(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	white_moves := bits.ones_count_64(reversi.neighbours(white_bitboard) & game.board.empty())
	black_moves := bits.ones_count_64(reversi.neighbours(black_bitboard) & game.board.empty())

	max, min := get_max_min(white_moves, black_moves, player)

	return ratio(max, min)
}

fn evaluate_stability(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	stable := u64(0)

	white_stable := bits.ones_count_64(white_bitboard & stable)
	black_stable := bits.ones_count_64(black_bitboard & stable)

	max, min := get_max_min(white_stable, black_stable, player)

	return ratio(max, min)
}

fn evaluate_korman(game reversi.Reversi, player reversi.Player) f64 {
	return 0
}

fn get_max_min[T](white T, black T, player reversi.Player) (T, T) {
	return match player {
		.white { white, black }
		.black { black, white }
	}
}

fn ratio(max int, min int) f64 {
	return if max > min {
		max / (max + min)
	} else if max < min {
		-min / (max + min)
	} else {
		0
	}
}
