extends Control

#UI NODE um das aktuelle Geld anzeigen zu lassen

onready var geldText = $Panel/VBoxContainer/HBoxContainer/Geld

var geld = 0

func _ready():
	change_geld(geld)

#Diese funktion wird aus StoryTrigger getriggert wenn das Signal emittet wird, das sich das Geld verändert hat.
func change_geld(new_geld):
	geldText.text = str(geld)
	
