extends CharacterBody2D
class_name Player

@export var max_hp: int = 100
var curr_hp: int = max_hp

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAV = 1000.0

var powers_toggled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAV * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


	if Input.is_action_just_pressed("toggle_powers"):
		
		powers_toggled = not powers_toggled
		if (powers_toggled):
			curr_hp = curr_hp - 5
		print(powers_toggled)
	

	move_and_slide()
