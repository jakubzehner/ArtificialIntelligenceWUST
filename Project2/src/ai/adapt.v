module ai

import reversi
import rand
import arrays
import math

const (
	weights_number   = 5
	number_of_adapts = 10
	elite            = 2
	new_adapts       = 1
	depth            = 4
	duels            = 3
	generations      = 30
)

struct Genome {
	weights []f64
}

struct Adapt {
	genome Genome
mut:
	wins int
}

pub fn learn_adapt() {
	mut adapts := []Adapt{}
	for _ in 0 .. ai.number_of_adapts {
		adapts << Adapt{new_genome(), 0}
	}

	for n in 0 .. ai.generations {
		for i in 0 .. adapts.len {
			adapts[i].wins = adapt_vs_others(adapts[i].genome)
		}

		if n == ai.generations - 1 {
			break
		}

		mut children := []Adapt{}
		adapts.sort(a.wins > b.wins)

		for j in 0 .. ai.elite {
			children << Adapt{adapts[j].genome, 0}
		}
		for _ in 0 .. ai.new_adapts {
			children << Adapt{new_genome(), 0}
		}

		for _ in 0 .. (ai.number_of_adapts - ai.elite - ai.new_adapts) {
			mut parents1 := rand.choose(adapts, 3) or { adapts }
			mut parents2 := rand.choose(adapts, 3) or { adapts }
			parents1.sort(a.wins > b.wins)
			parents2.sort(a.wins > b.wins)
			children << Adapt{make_child(parents1[0].genome, parents2[0].genome), 0}
		}

		println('\n\n\nGeneration ${n} done.\n\n\n')
	}

	adapts.sort(a.wins > b.wins)
	println('The best adapt: ${adapts[0].genome}')
}

fn new_genome() Genome {
	mut weights := []f64{}
	for _ in 0 .. ai.weights_number {
		weights << rand.f64()
	}

	return Genome{weights}
}

fn make_child(parent1 Genome, parent2 Genome) Genome {
	mut weights := []f64{}
	for i in 0 .. ai.weights_number {
		if rand.f64() > 0.5 {
			weights << parent1.weights[i]
		} else {
			weights << parent2.weights[i]
		}
		if rand.f64() > 0.5 {
			weights[i] += rand.f64() / 10
		} else {
			weights[i] -= rand.f64() / 10
		}
	}

	return Genome{weights}
}

fn evaluate_adapt_from_genome(game reversi.Reversi, player reversi.Player, genome Genome) f64 {
	return (genome.weights[0] * evaluate_corner_owned(game, player) +
		genome.weights[1] * evaluate_corner_closeness(game, player) +
		genome.weights[2] * evaluate_current_mobility(game, player) +
		genome.weights[3] * evaluate_coin_parity(game, player) +
		genome.weights[4] * evaluate_potential_mobility(game, player)) / arrays.sum(genome.weights) or {
		1
	}
}

fn adapt_vs_others(genome Genome) int {
	heuristics := [Heuristic.coin_parity, .corner_owned, .current_mobility, .potential_mobility,
		.corner_closeness, .weights, .korman]

	mut results := 0

	for heuristic in heuristics {
		results += adapt_vs_enemy(heuristic, genome)
	}

	println('Adapt ${genome.weights} vs others done with ${results} wins')
	return results
}

fn adapt_vs_enemy(enemy Heuristic, genome Genome) int {
	mut wins := 0

	for _ in 0 .. ai.duels {
		rev := game_after_5_random_moves()
		result := adapt_vs_computer(rev, enemy, .white, genome)

		if result == .white_winner {
			wins += 1
		}
	}

	for _ in 0 .. ai.duels {
		rev := game_after_5_random_moves()
		result := adapt_vs_computer(rev, enemy, .black, genome)

		if result == .black_winner {
			wins += 1
		}
	}

	return wins
}

fn adapt_vs_computer(game reversi.Reversi, enemy_heuristic Heuristic, adapt_player reversi.Player, genome Genome) reversi.Result {
	mut rev := game

	for !rev.is_game_over() {
		if !rev.can_move() {
			rev = rev.skip_turn()
			continue
		}

		if rev.turn() == adapt_player {
			_, move := adapt_alpha_beta(genome, adapt_player, rev, ai.depth, Action.max,
				math.inf(-1), math.inf(1))
			rev = rev.make_move(move)
		} else {
			move, _, _ := find_move_alpha_beta(rev, enemy_heuristic, ai.depth)
			rev = rev.make_move(move)
		}
	}

	return rev.result()
}

fn adapt_alpha_beta(genome Genome, player reversi.Player, game reversi.Reversi, depth int, action Action, alpha f64, beta f64) (f64, reversi.Move) {
	mut a, mut b := alpha, beta

	if game.is_game_over() {
		return evaluate_game_over(game, player), reversi.Move{}
	}

	if depth == 0 {
		return evaluate_adapt_from_genome(game, player, genome), reversi.Move{}
	}

	if !game.can_move() {
		return adapt_alpha_beta(genome, player, game.skip_turn(), depth - 1, action.opposite(),
			a, b)
	}

	mut available_moves := game.potential_moves_list()
	mut best_move := available_moves.pop()
	mut best_score, _ := adapt_alpha_beta(genome, player, game.make_move(best_move), depth - 1,
		action.opposite(), a, b)

	for move in available_moves {
		score, _ := adapt_alpha_beta(genome, player, game.make_move(move), depth - 1,
			action.opposite(), a, b)

		if better_score(best_score, score, action) {
			best_score = score
			best_move = move
		}

		// Alpha-beta pruning
		if game.turn() == player {
			a = math.max(a, score)
		} else {
			b = math.min(b, score)
		}
		if b <= a {
			break
		}
	}

	return best_score, best_move
}
