extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 150
export var friction = 0.18

# We map a direction to a frame index of our AnimatedSprite node's sprite frames.
# See how we use it below to update the character's look direction in the game.
var _sprites := {Vector2.RIGHT: 1, Vector2.LEFT: 2, Vector2.UP: 3, Vector2.DOWN: 4}
var _velocity := Vector2.ZERO
var dialogIsPlaying = false

onready var animated_sprite: AnimatedSprite = $AnimatedSprite




func _physics_process(_delta: float) -> void:
	# Once again, we call `Input.get_action_strength()` to support analog movement.
	var direction := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	# When aiming the joystick diagonally, the direction vector can have a length 
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player 
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)
	
	#move_and_slide(speed * direction)


# The code below updates the character's sprite to look in a specific direction.
func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		_update_sprite(Vector2.RIGHT)
	elif event.is_action_pressed("ui_left"):
		_update_sprite(Vector2.LEFT)
	elif event.is_action_pressed("ui_down"):
		_update_sprite(Vector2.DOWN)
	elif event.is_action_pressed("ui_up"):
		_update_sprite(Vector2.UP)


func _update_sprite(direction: Vector2) -> void:
	animated_sprite.frame = _sprites[direction]

#this function stops the player moving when in a dialog
func dialogPlaying(state):
	dialogIsPlaying = state
	if dialogIsPlaying == true:
		speed = 0
		print("Current Movement Speed: ", speed)
	else:
		speed = 150
		print("Current Movement Speed: ", speed)
