extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_NewGameBtn_pressed():
	get_tree().change_scene("res://Level/Level.tscn")
	
func _on_HelpBtn_pressed():
	get_tree().change_scene("res://MainMenu/Scenes/Help/HelpScene.tscn")
	
func _on_QuitBtn_pressed():
	get_tree().quit()

func _on_OptionsBtn_pressed():
	get_tree().change_scene("res://MainMenu/Scenes/Options/OptionsScene.tscn")
