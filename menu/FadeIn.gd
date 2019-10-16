extends ColorRect

signal fade_finished

class_name FadeIn

func fade_in():
	$AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
