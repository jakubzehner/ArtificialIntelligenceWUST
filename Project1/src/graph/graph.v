module graph

pub const walking_speed = f32(4) / f32(60) // in km per minute
pub const travel_speed = f32(15) / f32(60) // in km per minute

pub struct Graph {
	pos_to_name       map[string]string
	name_to_nodes_ids map[string][]int
	edges             [][]Edge
	nodes             []Node
}

pub fn (graph Graph) stats() {
	mut edges_n := 0
	for edge in graph.edges {
		edges_n += edge.len
	}
	println('Nodes: ${graph.nodes.len}')
	println('Edges: ${edges_n}')

	// println(graph.nodes[0])
}
