extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -400.0

const gravity = 24.0

const wall_jump_pushback = 100

const wall_slide_friction = 100
var is_wall_sliding = false



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handles jump and wall sliding
	jump()
	wall_slide(delta)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func jump():
	velocity.y += gravity
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("ui_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
		if is_on_wall() and Input.is_action_pressed("ui_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
			
func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (wall_slide_friction*delta)
		velocity.y = min(velocity.y, wall_slide_friction)
		
