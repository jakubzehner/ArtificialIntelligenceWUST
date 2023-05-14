module reversi

import term

pub fn (rev Reversi) print() {
	for line in board_to_string_array(rev.board) {
		for ch in line {
			eprint(ch)
		}
		eprint('\n')
	}
}

pub fn (rev Reversi) pretty_print_for_player() {
	print(' y01234567')
	

	rev.pretty_print()
}


pub fn (rev Reversi) pretty_print() {
	for line in board_to_string_array(rev.board) {
		for ch in line {
			eprint(colorize_string(ch))
		}
		eprint('\n')
	}
}

pub fn print_bitboard(bitboard Bitboard) {
	for row in 0 .. 8 {
		for col in 0 .. 8 {
			mask := xy_to_bitboard(col, row)
			if (bitboard & mask) != bitboard_empty {
				eprint(term.bg_white(term.gray('1')))
			} else {
				eprint(term.bg_black(term.gray('0')))
			}
		}
		eprint('\n')
	}
}

fn board_to_string_array(board Board) [][]string {
	mut result := [][]string{}
	for row in 0 .. 8 {
		result << []string{}
		for col in 0 .. 8 {
			mask := xy_to_bitboard(col, row)
			result[row] << if (board.white & mask) != bitboard_empty {
				'1'
			} else if (board.black & mask) != bitboard_empty {
				'2'
			} else {
				'0'
			}
		}
	}
	return result
}

fn colorize_string(str string) string {
	return match str {
		'0' { term.bg_green(term.bright_green(str)) }
		'1' { term.bg_white(term.gray('1')) }
		'2' { term.bg_black(term.gray('2')) }
		else { str }
	}
}
