module main

import os
import flag
import ai
import reversi
import time

fn main() {
	// ai.tournament(.alpha_beta, 5, time.second * 30)
	// ai.learn_adapt()
	// ai.game_after_5_random_moves().pretty_print()
	// return

	mut fp := flag.new_flag_parser(os.args)

	fp.application('Reversi step by step mode')
	fp.skip_executable()

	mode := fp.string('mode', `m`, 'pvc', 'Program mode, computer step by step, player vs computer, computer vs computer. Random returns board after 5 random moves. [step, pvc, cvc, random]').to_lower()
	player := fp.string('player', `p`, 'white', 'Player, which will play in step mode and pvc mode, or player which will start in cvc mode. [white/black]').to_lower()
	heuristic := fp.string('heuristic', `r`, 'coin_parity', 'Heuristic for the player. [coin_parity, corner_owned, corner_closeness, current_mobility, potential_mobility, weights, korman]').to_lower()
	heuristic2 := fp.string('heuristic2', `f`, 'coin_parity', 'Heuristic for the second player in cvc mode.')
	depth := fp.int('depth', `d`, 5, 'The depth for the algorithm.')
	depth2 := fp.int('depth2', `c`, 5, 'The depth for the second player in cvc mode.')
	algorithm := fp.string('algorithm', `a`, 'alpha_beta', 'Algorithm to use in pvc and cvc mode. [minimax, alpha_beta]')
	algorithm2 := fp.string('algorithm2', `z`, 'alpha_beta', 'Algorithm for the second player in cvc mode.')
	inp := fp.string('input', `i`, 'clean', 'Input mode, from clean board or from position. Only for pvc and cvc. [clean, position]')

	additional_args := fp.finalize()!
	if additional_args.len > 0 {
		panic('Incorrect arguments')
	}

	p1 := parse_player(player)
	h1 := parse_heuristic(heuristic)
	h2 := parse_heuristic(heuristic2)
	a1 := parse_algorithm(algorithm)
	a2 := parse_algorithm(algorithm2)
	d1 := depth
	d2 := depth2

	if mode == 'step' {
		step_mode(p1, h1, d1)!
		return
	} else if mode == 'random' {
		ai.game_after_5_random_moves().pretty_print()
	}

	game := match inp {
		'clean' {
			reversi.clean_start()
		}
		'position' {
			println('Podaj planszę początkową:')
			mut input_board := []string{}
			for _ in 0 .. 8 {
				input_board << os.input('')
			}
			reversi.from(input_board, p1)
		}
		else {
			panic('Incorrect input')
		}
	}

	match mode {
		'pvc' { player_vs_computer(game, p1, a1, h1, d1) }
		'cvc' { ai.computer_vs_computer(game, a1, a2, h1, h2, d1, d2, true) }
		else { panic('Incorrect mode') }
	}
}

fn step_mode(p reversi.Player, h ai.Heuristic, depth int) ! {
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

fn player_vs_computer(rev reversi.Reversi, player reversi.Player, algorithm ai.Algorithm, heuristic ai.Heuristic, depth int) {
	find_move := match algorithm {
		.minimax { ai.find_move_minimax }
		.alpha_beta { ai.find_move_alpha_beta }
	}

	mut game := rev
	mut sum_time := time.Duration(0)
	mut sum_visited := 0

	for !rev.is_game_over() {
		if !game.can_move() {
			game = game.skip_turn()
			continue
		}
		if game.turn() == player.opponent() {
			m, t, v := find_move(game, heuristic, depth)
			sum_time += t
			sum_visited += v
			game = game.make_move(m)
		} else {
			game.pretty_print_for_player()
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

	game.pretty_print()
	eprintln('Game result: ${game.result()}')
	eprintln('${player.opponent()} - algorithm: ${algorithm}, heuristic: ${heuristic}, depth: ${depth}, total time: ${sum_time}, total visited branches: ${sum_visited}')
	eprintln('${player} - human player.')
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

fn parse_algorithm(algorithm string) ai.Algorithm {
	return match algorithm {
		'minimax' { .minimax }
		'alpha_beta' { .alpha_beta }
		else { panic('Incorrect algorithm!') }
	}
}

fn move_to_output(move reversi.Move) string {
	return '${move.x},${move.y}'
}

fn input_to_move(move []string) reversi.Move {
	return reversi.Move{move[0].int(), move[1].int()}
}
