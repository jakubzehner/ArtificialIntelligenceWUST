module main

import ai
import reversi

fn main() {
	// start_pos := '00000000
	// 00200000
	// 00200000
	// 00212000
	// 00111000
	// 00210000
	// 00000000
	// 00000000'
	// 	rev := reversi.from(start_pos.split('\n'), reversi.Player.black)
	// 	rev.pretty_print()
	// 	println(rev.turn())
	// ai.test()

	mut rev := reversi.clean_start()
	ai.computer_vs_computer(rev, .alpha_beta, .alpha_beta, .coin_parity, .korman, 8, 6,
		true)
}
