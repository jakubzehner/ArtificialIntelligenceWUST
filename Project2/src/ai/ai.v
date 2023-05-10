module ai

import reversi

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
			move, time, visited := find_move_alpha_beta(rev, .coin_parity, 1)
			rev = rev.make_move(move)
			println('white moved: ${move.x}, ${move.y}, time: ${time}, visited: ${visited}')
		} else {
			move, time, visited := find_move_alpha_beta(rev, .corner_closeness, 15)
			rev = rev.make_move(move)
			println('black moved: ${move.x}, ${move.y}, time: ${time}, visited: ${visited}')
		}
	}
	println(rev.result())
	rev.pretty_print()
}
