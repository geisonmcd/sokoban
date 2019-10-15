extends CanvasLayer

func _ready():
	pass


func _on_Reload_pressed():
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	get_tree().change_scene("res://menu/TitleScreen.tscn")
