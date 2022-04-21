extends Control

var scene_path_to_load

func _ready():
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
#массив нужен для того, чтобы хранить там все эти кнопки, а не только одну

func _on_Button_pressed(scene_to_load):
	scene_path_to_load=scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()
#нужно для градиента

func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
#когда анимация градиента кончается, то показывает сцену, на которую перешли (ровно через 0.5 секунд)
