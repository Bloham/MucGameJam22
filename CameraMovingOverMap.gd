extends Path2D


export var speed = 100
onready var follow = $PathFollow2D

func _ready():
	set_process(true)

func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
