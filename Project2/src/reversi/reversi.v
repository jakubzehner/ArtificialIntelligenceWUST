module reversi

struct Reversi {
mut:
	board Board
}

pub fn (mut rev Reversi) test() {
	rev.pretty_print()
	// print_bitboard(rev.board.occupied())
	// print_bitboard(rev.board.empty())
	// print_bitboard(rev.white_potential_moves())
	// print_bitboard(rev.black_potential_moves())

	println('MOVE')
	rev.make_black_move(Move{2, 3})
	rev.make_white_move(Move{2, 2})
	rev.make_black_move(Move{2, 1})
	rev.make_white_move(Move{3, 5})
	rev.make_black_move(Move{2, 5})
	rev.make_white_move(Move{2, 4})
	rev.make_black_move(Move{5, 5})
	rev.make_white_move(Move{5, 2})


	rev.pretty_print()
	// print_bitboard(rev.board.occupied())
	// print_bitboard(rev.board.empty())
	// print_bitboard(rev.white_potential_moves())
	print_bitboard(rev.black_potential_moves())
	println(rev.black_potential_moves_list())
}

pub fn clean_start() Reversi {
	return Reversi{board_start()}
}

pub fn (rev Reversi) white_potential_moves() Bitboard {
	return potential_moves(rev.board.white, rev.board.black)
}

pub fn (rev Reversi) black_potential_moves() Bitboard {
	return potential_moves(rev.board.black, rev.board.white)
}

pub fn (rev Reversi) white_potential_moves_list() []Move {
	return potential_moves_list(rev.board.white, rev.board.black)
}

pub fn (rev Reversi) black_potential_moves_list() []Move {
	return potential_moves_list(rev.board.black, rev.board.white)
}

pub fn (mut rev Reversi) make_white_move(move Move) {
	white, black := board_after_move(move, rev.board.white, rev.board.black)
	rev.board = Board{white, black}
}

pub fn (mut rev Reversi) make_black_move(move Move) {
	black, white := board_after_move(move, rev.board.black, rev.board.white)
	rev.board = Board{white, black}
}
