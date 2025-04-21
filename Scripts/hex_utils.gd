extends Node
const direction_vectors : Dictionary[String, Vector3i] = {
	"East": Vector3i(1, 0, -1),
	"Southeast": Vector3i(0, 1, -1),
	"Southwest": Vector3i(-1, 1, 0),
	"West": Vector3i(-1, 0, 1),
	"Northwest": Vector3i(0, -1, 1),
	"Northeast": Vector3i(1, -1, 0),
}

const direction_angles : Dictionary[String, float] = {
	"East": 0,
	"Southeast": -PI/3,
	"Southwest": -2*PI/3,
	"West": PI,
	"Northwest": 2*PI/3,
	"Northeast": PI/3,
}

const root_3_over_2 = sqrt(3)/2

func cubic_hex_to_cartesian(cubic_coord : Vector3i):
	const q = Vector2(root_3_over_2, -0.5)
	const r = Vector2(0, 1)
	const s = Vector2(-root_3_over_2, -0.5)
	return cubic_coord.x * q + cubic_coord.y * r + cubic_coord.z * s
	
const radius = 4

func is_cubic_coord_valid(cubic_coord : Vector3i):
	return cubic_coord.x + cubic_coord.y + cubic_coord.z == 0

func is_cubic_coord_inbounds(cubic_coord):
	return max(abs(cubic_coord.x), abs(cubic_coord.y), abs(cubic_coord.z)) < radius
