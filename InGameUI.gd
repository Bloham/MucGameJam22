extends Control

#UI NODE um das aktuelle Geld anzeigen zu lassen

onready var geld = $Panel/VBoxContainer/HBoxContainer/Geld

func change_geld(new_geld):
	geld.text = str(new_geld)
