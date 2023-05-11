module reversi

pub struct Reversi {
pub:
	board  Board
	player Player
}

pub fn clean_start() Reversi {
	return Reversi{board_start(), Player.black}
}

pub fn from(str []string, start_player Player) Reversi {
	if str.len != 8 || str.any(it.trim_space().len != 8) {
		eprintln('Incorrect input, returned clean start')
		return clean_start()
	}

	return Reversi{board_from(str), start_player}
}

pub fn (rev Reversi) potential_moves() Bitboard {
	return match rev.player {
		.white { potential_moves(rev.board.white, rev.board.black) }
		.black { potential_moves(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) potential_moves_list() []Move {
	return match rev.player {
		.white { potential_moves_list(rev.board.white, rev.board.black) }
		.black { potential_moves_list(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) get_bitboards() (u64, u64) {
	return rev.board.white, rev.board.black
}

pub fn (rev Reversi) make_move(move Move) Reversi {
	white, black := match rev.player {
		.white {
			board_after_move(move, rev.board.white, rev.board.black)
		}
		.black {
			black, white := board_after_move(move, rev.board.black, rev.board.white)
			white, black
		}
	}

	return Reversi{Board{white, black}, rev.player.opponent()}
}

pub fn (rev Reversi) can_move() bool {
	return match rev.player {
		.white { has_move(rev.board.white, rev.board.black) }
		.black { has_move(rev.board.black, rev.board.white) }
	}
}

pub fn (rev Reversi) turn() Player {
	return rev.player
}

pub fn (rev Reversi) skip_turn() Reversi {
	if rev.can_move() {
		eprintln('It is illegal to skip a move having available moves!')
	}

	return Reversi{rev.board, rev.player.opponent()}
}

pub fn (rev Reversi) points() (int, int) {
	return rev.board.points()
}

pub fn (rev Reversi) is_game_over() bool {
	return !has_move(rev.board.white, rev.board.black)
		&& !has_move(rev.board.black, rev.board.white)
}

pub fn (rev Reversi) result() Result {
	if !rev.is_game_over() {
		eprintln('Picking a winner makes no sense if the game is not over!')
	}

	points_white, points_black := rev.points()
	return if points_white > points_black {
		Result.white_winner
	} else if points_black > points_white {
		Result.black_winner
	} else {
		Result.draw
	}
}
