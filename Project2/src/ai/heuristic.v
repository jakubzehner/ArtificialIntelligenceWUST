module ai

import reversi
import math.bits
import math

const corners = u64(0x8100000000000081)

const korman_weights_table = [20, -3, 11, 8, 8, 11, -3, 20, -3, -7, -4, 1, 1, -4, -7, -3, 11, -4,
	2, 2, 2, 2, -4, 11, 8, 1, 2, -3, -3, 2, 1, 8, 8, 1, 2, -3, -3, 2, 1, 8, 11, -4, 2, 2, 2, 2,
	-4, 11, -3, -7, -4, 1, 1, -4, -7, -3, 20, -3, 11, 8, 8, 11, -3, 20]

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

fn evaluate_stability(game reversi.Reversi, player reversi.Player) f64 {
	white_bitboard, black_bitboard := game.get_bitboards()
	stable := calculate_stable(game)

	white_stable := f64(bits.ones_count_64(white_bitboard & stable))
	black_stable := f64(bits.ones_count_64(black_bitboard & stable))

	max, min := get_max_min(white_stable, black_stable, player)

	return ratio(max, min)
}

fn evaluate_korman(game reversi.Reversi, player reversi.Player) f64 {
	return (802.0 * evaluate_corner_owned(game, player) +
		382.0 * evaluate_corner_closeness(game, player) +
		79.0 * evaluate_current_mobility(game, player) + 10.0 * evaluate_coin_parity(game, player) +
		74.0 * evaluate_potential_mobility(game, player) +
		100.0 * evaluate_stability(game, player) + 26.0 * korman_weights(game, player)) / 1473.0
}

fn korman_weights(game reversi.Reversi, player reversi.Player) f64 {
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

fn calculate_stable(game reversi.Reversi) u64 {
	mut queue := []reversi.Move{}
	mut visited := []reversi.Move{}
	mut stable := u64(0)

	corner := game.board.occupied() & ai.corners
	stable |= corner
	queue << reversi.moves(corner)

	for queue.len != 0 {
		source := queue.pop()
		if visited.contains(source) {
			continue
		}
		visited << source

		for pos in source.neighbours() {
			mut is_stable := true
			for line in reversi.diagonals(pos) {
				neighbours := reversi.moves(line)
				if neighbours.len == 2 && neighbours.all(at(game, pos) != at(game, it)
					|| reversi.has(stable, it)) {
					is_stable = false
				}
			}
			if is_stable {
				stable |= reversi.move_to_bitboard(pos)
				queue << pos
			}
		}
	}

	return stable
}

fn at(game reversi.Reversi, move reversi.Move) int {
	white_board, black_board := game.get_bitboards()
	white_has := reversi.has(white_board, move)
	black_has := reversi.has(black_board, move)

	return if !white_has && !black_has {
		1
	} else if white_has && !black_has {
		2
	} else if !white_has && black_has {
		3
	} else {
		4
	}
}