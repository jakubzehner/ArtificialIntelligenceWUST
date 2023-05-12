module main

import os
import flag
import ai
import reversi
import time

fn main() {
	// step_mode()!

	// ai.computer_vs_computer(reversi.clean_start(), .minimax, .minimax, .coin_parity, .coin_parity,
	// 	4, 4, true)
	// ai.computer_vs_computer(reversi.clean_start(), .minimax, .minimax, .coin_parity, .coin_parity,
	// 	5, 5, true)
	// ai.computer_vs_computer(reversi.clean_start(), .minimax, .minimax, .coin_parity, .coin_parity,
	// 	6, 6, true)
	// ai.computer_vs_computer(reversi.clean_start(), .minimax, .minimax, .coin_parity, .coin_parity,
	// 	7, 7, true)
	// ai.computer_vs_computer(reversi.clean_start(), .minimax, .minimax, .coin_parity, .coin_parity,
	// 	8, 8, true)
	//
	// ai.computer_vs_computer(reversi.clean_start(), .alpha_beta, .alpha_beta, .coin_parity,
	// 	.coin_parity, 4, 4, true)
	// ai.computer_vs_computer(reversi.clean_start(), .alpha_beta, .alpha_beta, .coin_parity,
	// 	.coin_parity, 5, 5, true)
	// ai.computer_vs_computer(reversi.clean_start(), .alpha_beta, .alpha_beta, .coin_parity,
	// 	.coin_parity, 6, 6, true)
	// ai.computer_vs_computer(reversi.clean_start(), .alpha_beta, .alpha_beta, .coin_parity,
	// 	.coin_parity, 7, 7, true)
	// ai.computer_vs_computer(reversi.clean_start(), .alpha_beta, .alpha_beta, .coin_parity,
	// 	.coin_parity, 8, 8, true)

	ai.tournament(.alpha_beta, 5, time.second * 30)

	// ai.learn_adapt()
}

fn step_mode() ! {
	mut fp := flag.new_flag_parser(os.args)

	fp.application('Reversi step by step mode')
	fp.skip_executable()

	player := fp.string('player', `p`, 'white', 'Player, which will play. [white/black]').to_lower()
	depth := fp.int('depth', `d`, 5, 'The depth for the algorithm.')
	heuristic := fp.string('heuristic', `m`, 'coin_parity', 'Heuristic for the player. [coin_parity, corner_owned, corner_closeness, current_mobility, potential_mobility, weights, korman]')

	additional_args := fp.finalize()!
	if additional_args.len > 0 {
		panic('Incorrect arguments')
	}

	h := parse_heuristic(heuristic)
	p := parse_player(player)

	mut sum_time := time.Duration(0)
	mut sum_visited := 0

	mut game := reversi.clean_start()
	if p == .black {
		m, t, v := ai.find_move_alpha_beta(game, h, depth)
		sum_time += t
		sum_visited += v
		game = game.make_move(m)
		println(move_to_output(m))
	}

	for !game.is_game_over() {
		if !game.can_move() {
			game = game.skip_turn()
			continue
		}
		if game.turn() == p {
			m, t, v := ai.find_move_alpha_beta(game, h, depth)
			sum_time += t
			sum_visited += v
			game = game.make_move(m)
			println(move_to_output(m))
		} else {
			mut inp := ''
			mut moves := []string{}
			for inp.is_blank() || moves.len != 2 {
				inp = os.input('')
				moves = inp.split(',')
			}
			move := input_to_move(moves)
			game = game.make_move(move)
		}
	}

	if p == .black {
		game.pretty_print()
		eprintln('Game result: ${game.result()}')
		eprintln('Black - heuristic: ${h}, depth: ${depth}, total time: ${sum_time}, total visited branches: ${sum_visited}')
	} else {
		time.sleep(time.millisecond * 10)
		eprintln('White - heuristic: ${h}, depth: ${depth}, total time: ${sum_time}, total visited branches: ${sum_visited}')
	}
}

fn parse_heuristic(heuristic string) ai.Heuristic {
	return match heuristic {
		'coin_parity' { .coin_parity }
		'corner_owned' { .corner_owned }
		'corner_closeness' { .corner_closeness }
		'current_mobility' { .current_mobility }
		'potential_mobility' { .potential_mobility }
		'weights' { .weights }
		'korman' { .korman }
		else { panic('Incorrect heuristic!') }
	}
}

fn parse_player(player string) reversi.Player {
	return match player {
		'white' { .white }
		'black' { .black }
		else { panic('Incorrect player!') }
	}
}

fn move_to_output(move reversi.Move) string {
	return '${move.x},${move.y}'
}

fn input_to_move(move []string) reversi.Move {
	return reversi.Move{move[0].int(), move[1].int()}
}
