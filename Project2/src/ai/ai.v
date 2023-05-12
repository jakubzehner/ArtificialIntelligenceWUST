module ai

import reversi
import time

pub enum Algorithm {
	minimax
	alpha_beta
}

pub fn tournament(algorithm Algorithm, depth int, time_limit time.Duration) {
	heuristics := [Heuristic.coin_parity, .corner_owned, .current_mobility, .potential_mobility,
		.corner_closeness, .weights, .korman]

	mut results := [][]f64{len: heuristics.len, init: []f64{len: heuristics.len}}

	for w_idx, white_heuristic in heuristics {
		for b_idx, black_heuristic in heuristics {
			results[w_idx][b_idx] = tournament_part(algorithm, depth, time_limit, white_heuristic,
				black_heuristic)
		}
	}

	println('')
	pretty_print_tournament_result(results, heuristics, algorithm, depth, time_limit)
}

fn tournament_part(algorithm Algorithm, depth int, time_limit time.Duration, white_heuristic Heuristic, black_heuristic Heuristic) f64 {
	mut white_won := 0
	mut black_won := 0
	mut draws := 0
	mut n := 0

	timer := time.now()
	for {
		rev := game_after_5_random_moves()
		result := computer_vs_computer(rev, algorithm, algorithm, white_heuristic, black_heuristic,
			depth, depth, false)

		match result {
			.black_winner { black_won += 1 }
			.white_winner { white_won += 1 }
			.draw { draws += 1 }
		}

		n += 1
		if time.now() - timer > time_limit {
			break
		}
	}

	println('${n} duels ${white_heuristic} vs ${black_heuristic} done after ${time.now() - timer}.')
	return f64(white_won) / f64(white_won + black_won + draws)
}

pub fn computer_vs_computer(game reversi.Reversi, white_algorithm Algorithm, black_algorithm Algorithm, white_heuristic Heuristic, black_heuristic Heuristic, white_depth int, black_depth int, print_data bool) reversi.Result {
	mut rev := game
	mut white_sum_time := time.Duration(0)
	mut black_sum_time := time.Duration(0)
	mut white_sum_visited := 0
	mut black_sum_visited := 0

	// mut n := 1
	for !rev.is_game_over() {
		// println('Move ${n}')
		// n += 1
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
		eprintln('White - algorithm: ${white_algorithm}, heuristic: ${white_heuristic}, depth: ${white_depth}, total time: ${white_sum_time}, total visited branches: ${white_sum_visited}')
		eprintln('Black - algorithm: ${black_algorithm}, heuristic: ${black_heuristic}, depth: ${black_depth}, total time: ${black_sum_time}, total visited branches: ${black_sum_visited}')
		eprintln('Game result: ${rev.result()}')
	}

	return rev.result()
}
