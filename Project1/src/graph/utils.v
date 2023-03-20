module graph

import simple_time { SimpleTime }

struct HeapItem {
	cost int
	node int
}

fn (item1 HeapItem) < (item2 HeapItem) bool {
	return item1.cost < item2.cost
}

fn (item1 HeapItem) == (item2 HeapItem) bool {
	return item1.cost == item2.cost
}
fn find_nearest_node(start string, start_t string, g Graph) int {
	t := simple_time.from(start_t)
	mut id := -1
	mut node_t := SimpleTime{1440}
	for node_id in g.name_to_nodes_ids[start] {
		node := g.nodes[node_id]
		if node.time < node_t && node.time >= t {
			id = node_id
			node_t = node.time
		}
	}
	return id
}

fn reached_destination(node int, end string, g Graph) bool {
	return g.pos_to_name[g.nodes[node].pos.short_str()] == end
}
