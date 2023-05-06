module main

import reversi

fn main() {
	mut game := reversi.clean_start()

	game.test()
}
