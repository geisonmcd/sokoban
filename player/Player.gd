extends KinematicBody2D

class_name Player
onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var tween : Tween = $Tween
export var move_speed : = 250.0
export var push_speed : = 125.0
export var sliding_time : = 0.3
var sliding : = false
var tile_map : TileMap

func initialize(_tile_map: TileMap) -> void:
	tile_map = _tile_map
	position = calculate_destination(Vector2())


func _physics_process(delta: float) -> void:
	var motion : = Vector2()
	motion.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
	motion.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
	update_animation(motion)
	move(push_speed * motion)
	if get_slide_count() > 0:
		check_box_collision(motion)

#func move(motion: Vector2):
##	var destination : = calculate_destination(motion.normalized())
#	var move_to : = calculate_destination(motion.normalized())
#	tween.interpolate_property(self, 
#			"global_position",
#			global_position,
#			destination,
#			sliding_time,
#			Tween.TRANS_CUBIC,
#			Tween.EASE_OUT)
#	tween.start()
#	sliding = true
#	yield(tween, "tween_completed")
#	sliding = false
	
func move(velocity: Vector2) -> void:
	print(global_position)
	if sliding:
		return
	var move_to := calculate_destination(velocity.normalized())
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
	print(tile_map_position)
	return tile_map.map_to_world(tile_map_position)

func update_animation(motion: Vector2) -> void:
	var animation : = "idle"
	if motion.x > 0:
		animation = "right"
	elif motion.x < 0:
		animation = "left"
	elif motion.y < 0:
		animation = "up"
	elif motion.y > 0:
		animation = "down"
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)

func check_box_collision(motion: Vector2) -> void:
	if abs(motion.x) + abs(motion.y) > 1:
		return
	var box : = get_slide_collision(0).collider as Box
	if box:
		box.push(push_speed * motion)