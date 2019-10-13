extends Box
class_name GridBox

onready var tween : Tween = $Tween

export var sliding_time : = 0.3

var tile_map : TileMap
var sliding : = false
onready var label : Label = get_parent().get_node("Label")


func initialize(_tile_map: TileMap) -> void:
	tile_map = _tile_map
	position = calculate_destination(Vector2())

func push(velocity: Vector2) -> void:
	if sliding:
		return
	var move_to : = calculate_destination(velocity.normalized())
	if can_move(move_to):
		tween.interpolate_property(self, 
			"global_position",
			global_position,
			move_to,
			sliding_time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT)
		tween.start()
		sliding = true
		yield(tween, "tween_completed")
		sliding = false

func calculate_destination(direction: Vector2) -> Vector2:
	var tile_map_position = tile_map.world_to_map(global_position) + direction
	return tile_map.map_to_world(tile_map_position)


func can_move(move_to: Vector2) -> bool:
	var future_transform : = Transform2D(transform)
	future_transform.origin = move_to
	return not test_move(future_transform, Vector2())
