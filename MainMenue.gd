extends Control


func _on_StartGame_button_down():
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.


func _on_QuitGame_button_down():
	get_tree().quit()
