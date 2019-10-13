extends Area2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

class_name RedPlatform
signal pressed
signal unpressed

func initialize(_floor: TileMap) -> void:
	connect("pressed", _floor, "_on_RedPlatform_pressed")
	connect("unpressed", _floor, "_on_RedPlatform_unpressed")
	
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: PhysicsBody2D) -> void:
	if not body is Box:
		return
	animated_sprite.play("down")
	emit_signal("pressed")


func _on_body_exited(body: PhysicsBody2D) -> void:
	if not body is Box:
		return
	animated_sprite.play("up")
	emit_signal("unpressed")