module graph

import position { Position }
import simple_time { SimpleTime }

const dummy_edge = EdgeWait{-1, -1}

type Edge = EdgeRide | EdgeWait | EdgeWalk

struct EdgeRide {
	start int
	end   int
	line  string
}

struct EdgeWalk {
	start int
	end   int
}

struct EdgeWait {
	start int
	end   int
}

struct Node {
	pos  Position
	time SimpleTime
}

fn (node Node) short_str() string {
	return '${node.pos.short_str()};${node.time.short_str()}'
}
