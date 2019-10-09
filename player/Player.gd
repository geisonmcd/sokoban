extends KinematicBody2D

class_name Player

export var push_speed : = 125.0
export var move_speed : = 64.0
var block_size : = 64
var moving : = false
var initial_position := Vector2()
var last_position := Vector2()
var direction := Vector2()
var count_stop := 0

func _ready():
	initial_position = get_position()
	
func _physics_process(delta: float) -> void:
	if !moving:
		count_stop = 0
		direction.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
		direction.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
		
		if abs(direction.x) + abs(direction.y) > 1:
			moving = false
			direction.x = 0
			direction.y = 0
			update_animation(direction)
			return
			
		initial_position = get_position()
		moving = Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")
		

	update_animation(direction)
	
	if moving:
		move_and_slide(direction.normalized() * move_speed, Vector2())
		last_position = get_position()

	if get_slide_count() > 0:
		check_box_collision(direction)
		if get_slide_collision(0).collider as TileMap: 
			moving = false
			direction.x = 0
			direction.y = 0
	
	var finish := direction.x == 1 && ((initial_position.x + block_size) <= get_position().x)
	finish = finish || direction.x == -1 && ((initial_position.x - block_size) >= get_position().x)
	finish = finish || direction.y == 1 && ((initial_position.y + block_size) <= get_position().y)
	finish = finish || direction.y == -1 && ((initial_position.y - block_size) >= get_position().y)
	
	if finish:
		moving = false
		direction.x = 0
		direction.y = 0
		
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
	#Isso aqui é pra não empurrar a caixa na horizontal, ou seja o vetor (motion) vai estar (1,1). 1 + 1 = 2
	if abs(motion.x) + abs(motion.y) > 1:
		return
	var box : = get_slide_collision(0).collider as Box
	if box:
		box.push(push_speed * motion)