@tool
extends EditorScript
	
func add_tile(grid_scene, tile_scene, cubic_coord):
	var tile_instance = tile_scene.instantiate()
	tile_instance.name = str(cubic_coord.x) + "|" + str(cubic_coord.y) + "|" + str(cubic_coord.z)
	var current_coord = HexUtils.cubic_hex_to_cartesian(cubic_coord)
	tile_instance.transform.origin.x = current_coord.x
	tile_instance.transform.origin.y = 0
	tile_instance.transform.origin.z = current_coord.y
	grid_scene.add_child(tile_instance)
	tile_instance.owner = grid_scene

func _run():
	var grid_scene = get_scene()
	if grid_scene.name != "Grid":
		return
	
	var tile_scene = load("res://Components/Tile.tscn")

	add_tile(grid_scene, tile_scene, Vector3i(0, 0, 0))
	for radius in range(HexUtils.radius):
		var current_corner_tile = radius * HexUtils.direction_vectors["Northwest"]
		# start in the top left
		for direction_vector in HexUtils.direction_vectors.values():
			for i in radius:
				var current_tile = current_corner_tile + i * direction_vector
				add_tile(grid_scene, tile_scene, current_tile)
			current_corner_tile = current_corner_tile + radius * direction_vector
