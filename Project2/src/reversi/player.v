module reversi

pub enum Player {
	white
	black
}

fn opponent(player Player) Player {
	return match player {
		.white { .black }
		.black { .white }
	}
}
