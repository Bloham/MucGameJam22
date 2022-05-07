extends Node



onready var player = get_tree().get_root().get_node("Main").get_node("Spielwelt").get_node("Player")

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
		
		#"ContinueDialog":
			#print("Dialog wir nicht geklöscht")
			#player.dialogPlaying()
		
		"EndDialog":
			print("Dialog beendet")
			player.dialogPlaying(false)
			self.queue_free()
			pass

