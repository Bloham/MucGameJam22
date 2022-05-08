extends Control

#UI NODE um das aktuelle Geld anzeigen zu lassen

onready var geldText = $Panel/VBoxContainer/HBoxContainer/Geld

export var startGeld = 0

func _ready():
	change_geld(startGeld)

#Diese funktion wird aus StoryTrigger getriggert wenn das Signal emittet wird, das sich das Geld verändert hat.
func change_geld(new_geld):
	print("Geld wird upgedated...", new_geld)
	geldText.text = str(new_geld)
	
