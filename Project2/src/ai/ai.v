module ai

import reversi { Move }

pub fn test() {
	// mut rev := reversi.clean_start()
	// rev = rev.make_move(Move{2, 3})
	// rev = rev.make_move(Move{2, 2})
	// rev = rev.make_move(Move{2, 1})
	// rev = rev.make_move(Move{3, 5})
	// rev = rev.make_move(Move{2, 5})
	// rev = rev.make_move(Move{2, 4})
	// rev.pretty_print()
	// println(rev.turn())
	// reversi.print_bitboard(rev.potential_moves())
	//
	// move, _, _ := find_move(rev, .coin_parity, 1)
	// rev = rev.make_move(move)
	// rev.pretty_print()
	//

	// mut rev := reversi.clean_start()
	// rev = rev.make_move(Move{4, 5})
	// rev = rev.make_move(Move{5, 3})
	// rev = rev.make_move(Move{6, 2})
	// rev = rev.make_move(Move{4, 6})
	// rev = rev.make_move(Move{2, 3})
	// rev = rev.make_move(Move{7, 1})
	// rev = rev.make_move(Move{4, 7})
	// rev = rev.make_move(Move{3, 5})
	// rev = rev.make_move(Move{3, 6})
	// rev = rev.make_move(Move{1, 3})
	// rev = rev.make_move(Move{4, 2})
	// rev = rev.make_move(Move{3, 7})
	// rev = rev.make_move(Move{0, 3})
	// rev = rev.make_move(Move{5, 7})
	// rev = rev.make_move(Move{2, 5})
	// rev = rev.make_move(Move{4, 1})
	// rev = rev.make_move(Move{6, 3})
	// rev = rev.make_move(Move{1, 4})
	// rev = rev.make_move(Move{4, 0})
	// rev = rev.make_move(Move{1, 2})
	// rev = rev.make_move(Move{1, 6})
	// rev = rev.make_move(Move{3, 2})
	// rev = rev.make_move(Move{0, 5})
	// rev = rev.make_move(Move{0, 7})
	// rev = rev.make_move(Move{0, 1})
	// rev = rev.make_move(Move{5, 1})
	// rev = rev.make_move(Move{2, 6})
	// rev = rev.make_move(Move{7, 3})
	// rev = rev.make_move(Move{5, 6})
	// rev = rev.make_move(Move{2, 1})
	// rev = rev.make_move(Move{3, 0})
	// rev = rev.make_move(Move{2, 7})
	// rev = rev.make_move(Move{3, 1})
	// rev = rev.make_move(Move{1, 0})
	// rev = rev.make_move(Move{6, 0})
	// rev = rev.make_move(Move{6, 6})
	// rev = rev.make_move(Move{6, 7})
	// rev = rev.make_move(Move{1, 1})
	// rev = rev.make_move(Move{1, 7})
	// rev = rev.make_move(Move{7, 7})
	// rev = rev.make_move(Move{7, 6})
	// rev = rev.make_move(Move{7, 5})
	// rev = rev.make_move(Move{0, 6})
	// rev = rev.make_move(Move{5, 0})
	// rev = rev.make_move(Move{5, 2})
	// rev = rev.make_move(Move{0, 4})
	// rev = rev.make_move(Move{2, 4})
	// rev = rev.make_move(Move{6, 5})
	// rev = rev.make_move(Move{2, 2})
	// rev = rev.make_move(Move{5, 5})
	// rev = rev.make_move(Move{0, 2})
	// rev = rev.make_move(Move{1, 5})
	// rev = rev.make_move(Move{2, 0})
	// rev = rev.make_move(Move{0, 0})
	// rev = rev.make_move(Move{6, 1})
	// rev = rev.make_move(Move{5, 4})
	// rev = rev.make_move(Move{6, 4})
	// rev = rev.make_move(Move{7, 4})
	//
	// rev.pretty_print()
	// println(rev.turn())
	// reversi.print_bitboard(rev.potential_moves())
	//
	// rev = rev.skip_turn()
	// rev.pretty_print()
	// println(rev.turn())
	// reversi.print_bitboard(rev.potential_moves())

	test_game()
}

pub fn test_game() {
	mut rev := reversi.clean_start()
	for !rev.is_game_over() {
		if !rev.can_move() {
			rev = rev.skip_turn()
			continue
		}

		if rev.turn() == .white {
			move, time, visited := find_move(rev, .coin_parity, 1)
			rev = rev.make_move(move)
			println('white moved: ${move.x}, ${move.y}, time: ${time}, visited: ${visited}')
		} else {
			move, time, visited := find_move(rev, .coin_parity, 5)
			rev = rev.make_move(move)
			println('black moved: ${move.x}, ${move.y}, time: ${time}, visited: ${visited}')
		}
	}
	println(rev.result())
	rev.pretty_print()
}
