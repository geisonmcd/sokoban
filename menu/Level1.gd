extends TextureButton

class_name Button2

export(String, FILE, "*.tscn") var scene_to_load

var _fadeIn := null

func initialize(fadeIn: FadeIn):
	print(fadeIn)
	_fadeIn = fadeIn
	if _fadeIn:
		_fadeIn.connect("fade_finished", self, "_on_fade_finished")
	
func _on_ButtonLevel_pressed():
	if !_fadeIn:
		get_tree().change_scene(scene_to_load)
		return
		
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_fade_finished():
	get_tree().change_scene(scene_to_load)