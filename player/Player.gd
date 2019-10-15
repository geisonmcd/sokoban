extends KinematicBody2D

class_name Player

export var push_speed : = 125.0
export var move_speed : = 200.0
var moving : = false
var next_position := Vector2()
var direction := Vector2()
var tile_map : TileMap
	
func initialize(_tile_map: TileMap) -> void:
	tile_map = _tile_map
	
func _physics_process(delta: float) -> void:
	if !moving:
		direction.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
		direction.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
		
		if !can_move(direction):
			reset_moving_and_direction()
			update_animation(direction)
			return
		
		moving = abs(direction.x) + abs(direction.y) > 0
		if moving:
			next_position = get_next_position(direction)

	update_animation(direction)
	if !moving:
		return

	move_and_slide(direction.normalized() * move_speed, Vector2())
	
	if get_slide_count() > 0:
		check_box_collision(direction)

	if test_finish_move(direction, next_position):
		reset_moving_and_direction()
		
func test_finish_move(direction, finish_position: Vector2) -> bool:
	var finish = direction.x == 1 && ((next_position.x) <= get_position().x)
	finish = finish || direction.x == -1 && ((next_position.x) >= get_position().x)
	finish = finish || direction.y == 1 && ((next_position.y) <= get_position().y)
	finish = finish || direction.y == -1 && ((next_position.y) >= get_position().y)
	
	return finish
	
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
	
	if $AnimatedSprite.animation != animation:
		$AnimatedSprite.play(animation)

func check_box_collision(motion: Vector2) -> void:
	if get_slide_collision(0).collider as TileMap:
		reset_moving_and_direction()
		
	#Isso aqui é pra não empurrar a caixa na horizontal, ou seja o vetor (motion) vai estar (1,1). 1 + 1 = 2	
	if abs(motion.x) + abs(motion.y) > 1:
		return

	var box : = get_slide_collision(0).collider as Box
	if !box:
		return
		
	if box.can_move(box.calculate_destination((push_speed * motion).normalized())):
		box.push(push_speed * motion)
	else:
		reset_moving_and_direction()

func reset_moving_and_direction():
	moving = false
	direction.x = 0
	direction.y = 0
	
func can_move(direction: Vector2) -> bool:
	return (abs(direction.x) + abs(direction.y) < 2) && !tile_map.check_complete_level()
	
func get_position2(velocity: Vector2) -> Vector2:
	return calculate_destination(velocity.normalized())
	
func calculate_destination(direction: Vector2) -> Vector2:
	var tile_map_position = tile_map.world_to_map(global_position) + direction
	return tile_map.map_to_world(tile_map_position)

func get_next_position(direction: Vector2) -> Vector2:
	var _position = get_position2(direction * move_speed)
	print("Position: ", _position)
	if direction.x != 0:
		_position.x += 32
	if direction.y != 0:
		_position.y += 32
		
	return _position