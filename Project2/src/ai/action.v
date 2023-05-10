module ai

enum Action {
	min
	max
}

fn (action Action) opposite() Action {
	return match action {
		.min { .max }
		.max { .min }
	}
}
