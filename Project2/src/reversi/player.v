module reversi

pub enum Player {
	white
	black
}

fn (player Player) opponent() Player {
	return match player {
		.white { .black }
		.black { .white }
	}
}
