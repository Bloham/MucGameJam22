extends Node



onready var player = get_tree().get_root().get_node("Main").get_node("Spielwelt").get_node("Player")
onready var InGameUI = get_tree().get_root().get_node("Main").get_node("Sonstiges").get_node("UI").get_node("InGameUI")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		start_dialog(self.name)

func start_dialog(dialogName):
	var dialog = Dialogic.start(dialogName)
	dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(dialog)

func dialog_listener(string):
	match string:
		"StartDialog":
			print("Dialog gestartet mit ", player)
			player.dialogPlaying(true)
			pass
		
		"ContinueDialog":
			print("Dialog wir nicht gelöscht")
			player.dialogPlaying(false)
			pass
		
		"EndDialog":
			print("Dialog beendet")
			player.dialogPlaying(false)
			self.queue_free()
			pass
			
		"UpdateGeld":
			var geld = Dialogic.get_variable("geld")
			print("Update the geld panel with: ",geld)
			InGameUI.change_geld(geld)
			pass

