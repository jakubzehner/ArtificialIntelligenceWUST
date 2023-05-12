module reversi

pub struct Move {
pub:
	x int
	y int
}

pub fn moves(bitboard Bitboard) []Move {
	mut bb := bitboard
	mut result := []Move{cap: 64}
	mut i := 0

	for bb != bitboard_empty {
		if bb & 1 != bitboard_empty {
			result << index_to_move(i)
		}
		bb >>= 1
		i += 1
	}

	return result
}

pub fn (move Move) neighbours() []Move {
	return moves(neighbours(move_to_bitboard(move)))
}
