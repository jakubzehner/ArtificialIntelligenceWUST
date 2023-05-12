module reversi

pub enum Player {
	white
	black
}

pub fn (player Player) opponent() Player {
	return match player {
		.white { .black }
		.black { .white }
	}
}
