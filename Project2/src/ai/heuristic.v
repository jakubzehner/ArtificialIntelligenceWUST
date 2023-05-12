module ai

import reversi
import math.bits
import math

const corners = u64(0x8100000000000081)

// vfmt off
const korman_weights_table = [
	20, -3, 11,  8,  8, 11, -3, 20,
	-3, -7, -4,  1,  1, -4, -7, -3,
	11, -4,  2,  2,  2,  2, -4, 11,
	 8,  1,  2, -3, -3,  2,  1,  8,
	 8,  1,  2, -3, -3,  2,  1,  8,
	11, -4,  2,  2,  2,  2, -4, 11,
	-3, -7, -4,  1,  1, -4, -7, -3,
	20, -3, 11,  8,  8, 11, -3, 20,
]
// vfmt on

pub enum Heuristic {
	coin_parity
	corner_owned
	corner_closeness
	current_mobility
	potential_mobility
	weights
	korman
}

fn (heuristic Heuristic) evaluate(game reversi.Reversi, player reversi.Player) f64 {
	return match heuristic {
		.coin_parity { evaluate_coin_parity(game, player) }
		.corner_owned { evaluate_corner_owned(game, player) }
		.corner_closeness { evaluate_corner_closeness(game, player) }
		.current_mobility { evaluate_current_mobility(game, player) }
		.potential_mobility { evaluate_potential_mobility(game, player) }
		.weights { evaluate_weights(game, player) }
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
	mut result := 0.0
	for move in reversi.moves(ai.corners) {
		if reversi.has(game.board.empty(), move) {
			target := reversi.neighbours(reversi.move_to_bitboard(move))
			white_board, black_board := game.get_bitboards()
			white_sq := f64(bits.ones_count_64(target & white_board))
			black_sq := f64(bits.ones_count_64(target & black_board))

			max, min := get_max_min(white_sq, black_sq, player)
			result += -0.125 * f64(max - min)
		}
	}

	return result
}

fn evaluate_current_mobility(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	white_moves := f64(bits.ones_count_64(reversi.potential_moves(white_bitboard, black_bitboard)))
	black_moves := f64(bits.ones_count_64(reversi.potential_moves(black_bitboard, white_bitboard)))

	max, min := get_max_min(white_moves, black_moves, player)

	return ratio(max, min)
}

fn evaluate_potential_mobility(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	white_moves := f64(bits.ones_count_64(reversi.neighbours(white_bitboard) & game.board.empty()))
	black_moves := f64(bits.ones_count_64(reversi.neighbours(black_bitboard) & game.board.empty()))

	max, min := get_max_min(white_moves, black_moves, player)

	return ratio(max, min)
}

fn evaluate_korman(game reversi.Reversi, player reversi.Player) f64 {
	return (802.0 * evaluate_corner_owned(game, player) +
		382.0 * evaluate_corner_closeness(game, player) +
		79.0 * evaluate_current_mobility(game, player) + 10.0 * evaluate_coin_parity(game, player) +
		74.0 * evaluate_potential_mobility(game, player) + 26.0 * evaluate_weights(game, player)) / 1473.0
}

fn evaluate_weights(game reversi.Reversi, player reversi.Player) f64 {
	white_board, black_board := game.get_bitboards()
	mut max_bb, mut min_bb := get_max_min(white_board, black_board, player)

	mut total := 0.0
	mut max := 0.0
	for i in 0 .. 64 {
		total += (f64(max_bb & 1) - f64(min_bb & 1)) * f64(ai.korman_weights_table[i])
		max += f64(math.max(ai.korman_weights_table[i], 0))
		max_bb >>= 1
		min_bb >>= 1
	}

	return total / max
}

fn get_max_min[T](white T, black T, player reversi.Player) (T, T) {
	return match player {
		.white { white, black }
		.black { black, white }
	}
}

fn ratio(max f64, min f64) f64 {
	return if max > min {
		f64(max) / f64(max + min)
	} else if max < min {
		f64(-min) / f64(max + min)
	} else {
		0.0
	}
}
