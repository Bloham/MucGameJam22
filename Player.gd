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
var lines : Node




func _ready():
	lines = get_tree().get_root().get_node("Main/Spielwelt/WorldMap/Weglinien/AktiveWeglinien")


func _physics_process(_delta: float) -> void:
	# Once again, we call `Input.get_action_strength()` to support analog movement.
	var direction_input := Vector2(
		# This first line calculates the X direction, the vector's first component.
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		# And here, we calculate the Y direction. Note that the Y-axis points 
		# DOWN in games.
		# That is to say, a Y value of `1.0` points downward.
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	direction_input = direction_input.normalized()
		
	var direction_path = get_path_direction(direction_input)
		
	var target_velocity = direction_path * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)
	
	#move_and_slide(speed * direction)


var distance_to_path_max = 250.0
func get_path_direction(direction_input):
	var diretion_final = direction_input
	var intended = self.get_position() + direction_input
	var distance_min = 999
	var minimizing_line : Line2D
	var minimizing_point = 999
	
	for line in lines.get_children():
		var line_index = 0
		while line_index < line.points.size() - 1:
			var line_start = line.get_point_position(line_index)
			var line_end = line.get_point_position(line_index+1)
			var d = get_distance_point_to_lineSegment(intended, line_start, line_end)
			if d < distance_min:
				distance_min = d
				minimizing_line = line
				minimizing_point = line_index
			line_index += 1
	
	if distance_min > distance_to_path_max and distance_min < 999:
		print (" player oob by ",(distance_min - distance_to_path_max))
#		var line_start = minimizing_line.get_point_position(minimizing_point)
#		var line_end = minimizing_line.get_point_position(minimizing_point+1)
#		var intended_projected = get_point_projected_on_lineSegment(intended, line_start, line_end)
#		var d_diff = intended - intended_projected
#		var d_adjusted = d_diff.normalized() 
#		diretion_final = self.get_position() + d_adjusted
		
	return diretion_final


func get_distance_point_to_lineSegment(var p : Vector2, var line_start : Vector2, line_end : Vector2):
	var p_projection = get_point_projected_on_lineSegment(p, line_start, line_end)
	return p.distance_to(p_projection) 


func get_point_projected_on_lineSegment(var p : Vector2, var line_start : Vector2, line_end : Vector2):
	var l2 =line_start.distance_to(line_end)*line_start.distance_to(line_end)
	if l2 == 0:
		return p.distance_to(line_start)
	var t = ((p.x - line_start.x) * (line_end.x - line_start.x) + (p.y - line_start.y) * (line_end.y - line_start.y)) / l2
	t = max(0, min(1, t))
	return line_start + t * line_end - line_start


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
