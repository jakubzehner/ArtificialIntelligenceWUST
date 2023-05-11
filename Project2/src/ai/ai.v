module ai

import reversi
import time

pub enum Algorithm {
	minimax
	alpha_beta
}

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
}

pub fn tournament() {
}

pub fn computer_vs_computer(game reversi.Reversi, white_algorithm Algorithm, black_algorithm Algorithm, white_heuristic Heuristic, black_heuristic Heuristic, white_depth int, black_depth int, print_data bool) reversi.Result {
	mut rev := game
	mut white_sum_time := time.Duration(0)
	mut black_sum_time := time.Duration(0)
	mut white_sum_visited := 0
	mut black_sum_visited := 0

	for !rev.is_game_over() {
		if !rev.can_move() {
			rev = rev.skip_turn()
			continue
		}

		if rev.turn() == .white {
			move, t, visited := match white_algorithm {
				.minimax { find_move_minimax(rev, white_heuristic, white_depth) }
				.alpha_beta { find_move_alpha_beta(rev, white_heuristic, white_depth) }
			}

			rev = rev.make_move(move)
			white_sum_time += t
			white_sum_visited += visited
		} else {
			move, t, visited := match black_algorithm {
				.minimax { find_move_minimax(rev, black_heuristic, black_depth) }
				.alpha_beta { find_move_alpha_beta(rev, black_heuristic, black_depth) }
			}
			rev = rev.make_move(move)
			black_sum_time += t
			black_sum_visited += visited
		}
	}

	if print_data {
		rev.pretty_print()
		println('White - algorithm: ${white_algorithm}, heuristic: ${white_heuristic}, depth: ${white_depth}, total time: ${white_sum_time}, total visited branches: ${white_sum_visited}')
		println('Black - algorithm: ${black_algorithm}, heuristic: ${black_heuristic}, depth: ${black_depth}, total time: ${black_sum_time}, total visited branches: ${black_sum_visited}')
		println('Game result: ${rev.result()}')
	}

	return rev.result()
}
