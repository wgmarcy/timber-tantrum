extends CharacterBody3D

@export var movement_speed = 5

var cubic_position : Vector3i = Vector3i(0, 0, 0) : set = set_cubic_position

var source_coordinate : Vector3 = transform.origin
var target_coordinate : Vector3 = transform.origin
var grid_interp_t : float = 0

func set_cubic_position(pos):
	cubic_position = pos
	var new_position = HexUtils.cubic_hex_to_cartesian(cubic_position)
	target_coordinate = Vector3(new_position.x, 0, new_position.y)
	grid_interp_t = 0

func _ready():
	pass
	
func move_in_direction(direction):
	# face character in direction
	self.rotation.y = HexUtils.direction_angles[direction]
	
	# move character a tile if available
	var direction_vector = HexUtils.direction_vectors[direction]
	var target_position = cubic_position + direction_vector
	if HexUtils.is_cubic_coord_inbounds(target_position):
		cubic_position = target_position
	else:
		target_coordinate = source_coordinate
		grid_interp_t = 0

# returns true if lerping ended this iteration
func lerp_character(delta) -> bool:
	grid_interp_t += movement_speed * delta
	grid_interp_t = clamp(grid_interp_t, 0, 1)
	self.transform.origin = lerp(source_coordinate, target_coordinate, grid_interp_t)
	if grid_interp_t >= 1:
		source_coordinate = target_coordinate
		grid_interp_t = 0
		return true
	return false
	
func _process(delta):
	var character_should_lerp_on_action = true
	if source_coordinate != target_coordinate: # in transit
		character_should_lerp_on_action = lerp_character(delta)

	if source_coordinate == target_coordinate: # not moving
		if Input.is_action_pressed("p1_move_northwest"):
			move_in_direction("Northwest")
		elif Input.is_action_pressed("p1_move_northeast"):
			move_in_direction("Northeast")
		elif Input.is_action_pressed("p1_move_east"):
			move_in_direction("East")
		elif Input.is_action_pressed("p1_move_southeast"):
			move_in_direction("Southeast")
		elif Input.is_action_pressed("p1_move_southwest"):
			move_in_direction("Southwest")
		elif Input.is_action_pressed("p1_move_west"):
			move_in_direction("West")
		else:
			character_should_lerp_on_action = false
		
		if character_should_lerp_on_action:
			lerp_character(delta)
