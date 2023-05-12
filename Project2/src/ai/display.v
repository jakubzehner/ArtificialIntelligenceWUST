module ai

import term
import time

pub fn pretty_print_tournament_result(result [][]f64, names []Heuristic, algorithm Algorithm, depth int, time_limit time.Duration) {
	print_black_name_cell('  ')
	for name in names {
		print_black_name_cell(name_to_shortcut(name))
	}
	print('\n')

	for i, line in result {
		print_white_name_cell(name_to_shortcut(names[i]))
		for win_rate in line {
			print_result_cell(win_rate * 100)
		}

		print('\n')
	}

	alg := match algorithm {
		.minimax { 'MiniMax' }
		.alpha_beta { 'MiniMax with Alpha-Beta pruning' }
	}
	print('\n')
	println('Algorithm: ${alg}')
	println('Depth: ${depth}')
	println('Time limit for duels: ${time_limit}')
}

fn print_black_name_cell(name string) {
	print('   ${name}   ⎹')
}

fn print_white_name_cell(name string) {
	print(term.bg_white(term.black('   ${name}   ⎹')))
}

fn print_result_cell(win_rate f64) {
	helper := '${win_rate:04.1f}%'
	if win_rate > 55 {
		print(term.bg_white(term.black(' ${helper:6} ⎹')))
	} else if win_rate < 45 {
		print(' ${helper:6} ⎹')
	} else {
		print(term.bright_bg_black(term.white(' ${helper:6} ⎹')))
	}
}

fn name_to_shortcut(name Heuristic) string {
	return match name {
		.coin_parity { 'CP' }
		.corner_owned { 'CO' }
		.corner_closeness { 'CC' }
		.current_mobility { 'CM' }
		.potential_mobility { 'PM' }
		.weights { 'WE' }
		.korman { 'KO' }
		.adapt { 'AD' }
	}
}
