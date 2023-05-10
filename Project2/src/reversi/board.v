module reversi

import math.bits

// Bitboard implementation based on:
// https://github.com/brian112358/gpu-othello
type Bitboard = u64

const (
	bitboard_empty       = Bitboard(0x0000000000000000)
	bitboard_white_start = bitboard_empty | xy_to_bitboard(3, 3) | xy_to_bitboard(4, 4)
	bitboard_black_start = bitboard_empty | xy_to_bitboard(3, 4) | xy_to_bitboard(4, 3)
)

struct Board {
	white Bitboard
	black Bitboard
}

fn board_from(str []string) Board {
	// TODO
	return Board{}
}

fn board_start() Board {
	return Board{reversi.bitboard_white_start, reversi.bitboard_black_start}
}

fn (board Board) occupied() Bitboard {
	return board.white | board.black
}

fn (board Board) empty() Bitboard {
	return ~u64(board.occupied())
}

fn (board Board) points() (int, int) {
	return bits.ones_count_64(board.white), bits.ones_count_64(board.black)
}

fn has_move(current Bitboard, opponent Bitboard) bool {
	return potential_moves(current, opponent) != reversi.bitboard_empty
}

fn potential_moves(current Bitboard, opponent Bitboard) Bitboard {
	return all_attack(current, opponent) & ~(current | opponent)
}

fn potential_moves_list(current Bitboard, opponent Bitboard) []Move {
	moves := potential_moves(current, opponent)
	mut result := []Move{}
	for y in 0 .. 8 {
		for x in 0 .. 8 {
			if moves & xy_to_bitboard(x, y) != reversi.bitboard_empty {
				result << Move{x, y}
			}
		}
	}
	return result
}

fn board_after_move(move Move, current Bitboard, opponent Bitboard) (Bitboard, Bitboard) {
	move_bitboard := move_to_bitboard(move)

	if move_bitboard & potential_moves(current, opponent) == reversi.bitboard_empty {
		panic('Invalid move!')
	}

	flipped := all_sandwiched(move_bitboard, current, opponent)

	return current | move_bitboard | flipped, opponent ^ flipped
}

// Basic functions

[inline]
fn xy_to_index(x int, y int) int {
	return 8 * y + x
}

[inline]
fn move_to_index(move Move) int {
	return xy_to_index(move.x, move.y)
}

[inline]
fn index_to_move(index int) Move {
	return Move{index % 8, index / 8}
}

[inline]
fn index_to_bitboard(index int) Bitboard {
	return u64(1) << index
}

[inline]
fn xy_to_bitboard(x int, y int) Bitboard {
	return index_to_bitboard(xy_to_index(x, y))
}

[inline]
fn move_to_bitboard(move Move) Bitboard {
	return index_to_bitboard(move_to_index(move))
}

// Bitboard algorithms
// https://www.chessprogramming.org/Dumb7Fill
// https://www.chessprogramming.org/General_Setwise_Operations

/**
 *   NW           N          NE
 *         -9    -8    -7
 *             \  |  /
 *    W    -1 <-  0 -> +1    E
 *             /  |  \
 *         +7    +8    +9
 *   SW           S          SE
*/

const (
	east       = 1
	west       = -1
	north      = -8
	south      = 8
	north_west = -9
	north_east = -7
	south_west = 7
	south_east = 9
)

// Bitmasks to prevent wrapping around the E and W directions
const (
	not_e = Bitboard(0xFEFEFEFEFEFEFEFE)
	not_w = Bitboard(0x7F7F7F7F7F7F7F7F)
)

fn all_sandwiched(gen1 Bitboard, gen2 Bitboard, prop Bitboard) Bitboard {
	return s_fill(gen1, prop) & n_fill(gen2, prop) | n_fill(gen1, prop) & s_fill(gen2,
		prop) | e_fill(gen1, prop) & w_fill(gen2, prop) | se_fill(gen1, prop) & nw_fill(gen2,
		prop) | ne_fill(gen1, prop) & sw_fill(gen2, prop) | w_fill(gen1, prop) & e_fill(gen2,
		prop) | sw_fill(gen1, prop) & ne_fill(gen2, prop) | nw_fill(gen1, prop) & se_fill(gen2,
		prop)
}

fn all_attack(gen Bitboard, prop Bitboard) Bitboard {
	return s_shift(s_fill(gen, prop)) | n_shift(n_fill(gen, prop)) | e_shift(e_fill(gen,
		prop)) | se_shift(se_fill(gen, prop)) | ne_shift(ne_fill(gen, prop)) | w_shift(w_fill(gen,
		prop)) | sw_shift(sw_fill(gen, prop)) | nw_shift(nw_fill(gen, prop))
}

fn all_shift(gen Bitboard) Bitboard {
	return s_shift(gen) | n_shift(gen) | e_shift(gen) | se_shift(gen) | ne_shift(gen) | w_shift(gen) | sw_shift(gen) | nw_shift(gen)
}

fn diag_shift(gen Bitboard) Bitboard {
	return se_shift(gen) | ne_shift(gen) | sw_shift(gen) | nw_shift(gen)
}

fn card_shift(gen Bitboard) Bitboard {
	return s_shift(gen) | n_shift(gen) | e_shift(gen) | w_shift(gen)
}

// Dumb7Fill

fn fill(gen Bitboard, prop Bitboard, shift int) Bitboard {
	mut flood := Bitboard(0)
	mut temp_gen := gen

	for _ in 0 .. 6 {
		temp_gen = if shift > 0 { (temp_gen << shift) & prop } else { (temp_gen >> -shift) & prop }
		flood |= temp_gen
	}

	return flood
}

[inline]
fn s_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.south)
}

[inline]
fn n_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.north)
}

[inline]
fn e_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.east) & reversi.not_e
}

[inline]
fn ne_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.north_east) & reversi.not_e
}

[inline]
fn se_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.south_east) & reversi.not_e
}

[inline]
fn w_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.west) & reversi.not_w
}

[inline]
fn sw_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.south_west) & reversi.not_w
}

[inline]
fn nw_fill(gen Bitboard, prop Bitboard) Bitboard {
	return fill(gen, prop, reversi.north_west) & reversi.not_w
}

// Shift algorithms

[inline]
fn s_shift(bitboard Bitboard) Bitboard {
	return bitboard << 8
}

[inline]
fn n_shift(bitboard Bitboard) Bitboard {
	return bitboard >> 8
}

[inline]
fn e_shift(bitboard Bitboard) Bitboard {
	return bitboard << 1 & reversi.not_e
}

[inline]
fn se_shift(bitboard Bitboard) Bitboard {
	return bitboard << 9 & reversi.not_e
}

[inline]
fn ne_shift(bitboard Bitboard) Bitboard {
	return bitboard >> 7 & reversi.not_e
}

[inline]
fn w_shift(bitboard Bitboard) Bitboard {
	return bitboard >> 1 & reversi.not_w
}

[inline]
fn sw_shift(bitboard Bitboard) Bitboard {
	return bitboard << 7 & reversi.not_w
}

[inline]
fn nw_shift(bitboard Bitboard) Bitboard {
	return bitboard >> 9 & reversi.not_w
}
