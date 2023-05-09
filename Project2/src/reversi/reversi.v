module reversi

struct Reversi {
	board  Board
	player Player
}

pub fn test() {
	mut rev := clean_start()
	rev.pretty_print()
	// print_bitboard(rev.board.occupied())
	// print_bitboard(rev.board.empty())
	// print_bitboard(rev.white_potential_moves())
	// print_bitboard(rev.black_potential_moves())

	println('MOVE')
	rev = rev.make_move(Move{2, 3})
	rev = rev.make_move(Move{2, 2})
	rev = rev.make_move(Move{2, 1})
	rev = rev.make_move(Move{3, 5})
	rev = rev.make_move(Move{2, 5})
	rev = rev.make_move(Move{2, 4})
	rev = rev.make_move(Move{5, 5})
	rev = rev.make_move(Move{5, 2})
	rev = rev.make_move(Move{4, 5})

	rev.pretty_print()
	// print_bitboard(rev.board.occupied())
	// print_bitboard(rev.board.empty())
	// print_bitboard(rev.white_potential_moves())
	print_bitboard(rev.potential_moves())
	println(rev.potential_moves_list())
}

pub fn clean_start() Reversi {
	return Reversi{board_start(), Player.black}
}

pub fn (rev Reversi) potential_moves() Bitboard {
	return match rev.player {
		.white { potential_moves(rev.board.white, rev.board.black) }
		.black { potential_moves(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) potential_moves_list() []Move {
	return match rev.player {
		.white { potential_moves_list(rev.board.white, rev.board.black) }
		.black { potential_moves_list(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) make_move(move Move) Reversi {
	white, black := match rev.player {
		.white {
			board_after_move(move, rev.board.white, rev.board.black)
		}
		.black {
			black, white := board_after_move(move, rev.board.black, rev.board.white)
			white, black
		}
	}

	return Reversi{Board{white, black}, opponent(rev.player)}
}

pub fn (rev Reversi) can_move() bool {
	return match rev.player {
		.white { has_move(rev.board.white, rev.board.black) }
		.black { has_move(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) skip_turn() Reversi {
	if rev.can_move() {
		eprintln('It is illegal to skip a move having available moves!')
	}

	return Reversi{rev.board, opponent(rev.player)}
}
