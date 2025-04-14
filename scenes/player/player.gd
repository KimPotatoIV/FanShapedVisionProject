extends CharacterBody2D

##################################################
const MOVING_SPEED = 150.0

##################################################
func _physics_process(delta: float) -> void:
	var direction_x: float = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * MOVING_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVING_SPEED)

	var direction_y: float = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * MOVING_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, MOVING_SPEED)

	move_and_slide()
