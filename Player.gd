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
var mark : Node2D
var mark1 : Node2D
var mark2 : Node2D




func _ready():
	lines = get_tree().get_root().get_node("Main/Spielwelt/WorldMap/Weglinien/AktiveWeglinien")
#	mark = get_tree().get_root().get_node("Main/Spielwelt/mark")
#	mark1 = get_tree().get_root().get_node("Main/Spielwelt/mark0")
#	mark2 = get_tree().get_root().get_node("Main/Spielwelt/mark1")


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


var distance_to_path_max = 25.0
func get_path_direction(direction_input):
	var diretion_final = direction_input
	var intended = self.get_position() + direction_input
	var distance_min = 999999
	var minimizing_line : Line2D
	var minimizing_point = -1
	
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
			
	if distance_min > distance_to_path_max and minimizing_point > -1:
		var line_start = minimizing_line.get_point_position(minimizing_point)
		var line_end = minimizing_line.get_point_position(minimizing_point+1)
		var pos_projected = get_point_projected_on_lineSegment(self.get_position(), line_start, line_end)
		var d_diff = pos_projected - self.get_position()
		var d_adjusted = d_diff.normalized()
#		mark1.set_position(line_start)
#		mark2.set_position(line_end)
#		mark.set_position(intended_projected)
		print (" player dist to ",minimizing_line.name," node ",minimizing_point," is ",(distance_min - distance_to_path_max))
		diretion_final = d_adjusted
		
	return diretion_final


func get_distance_point_to_lineSegment(var p : Vector2, var line_start : Vector2, line_end : Vector2):
	return p.distance_to(get_point_projected_on_lineSegment(p, line_start, line_end))


func get_point_projected_on_lineSegment(var p : Vector2, var line_start : Vector2, line_end : Vector2):
	var l1 : float = line_start.distance_to(line_end)
	var l2 : float = l1*l1
	if l2 == 0:
		return p.distance_to(line_start)
		
	var t = (p - line_start).dot(line_end - line_start)
	t = max(0.0, min(1.0, t/l2))
	return line_start + t * (line_end - line_start)

	return line_start + t * (line_end - line_start)


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
