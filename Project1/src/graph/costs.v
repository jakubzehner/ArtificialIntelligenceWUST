module graph

fn simple_time_cost(from Edge, to Edge, g Graph) f64 {
	return calculate_travel_time(g.nodes[from.end], g.nodes[to.end])
}

fn simple_transfer_cost(from Edge, to Edge, _ Graph) f64 {
	return transfer_if_detected(from, to)
}

fn transfer_time_cost(from Edge, to Edge, g Graph) f64 {
	return f64(transfer_if_detected(from, to)) +
		f64(calculate_travel_time(g.nodes[from.end], g.nodes[to.end])) / 10_000.0
}

fn transfer_penalty_time_cost(from Edge, to Edge, g Graph) f64 {
	return f64(calculate_travel_time(g.nodes[from.end], g.nodes[to.end])) +
		f64(transfer_if_detected(from, to) * 60)
}
