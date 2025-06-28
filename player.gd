extends CharacterBody2D
class_name Player

@export var max_hp: int = 100
var curr_hp: int = max_hp

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV = 2000.0

var powers_toggled = false

func _ready() -> void:
	pass

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
			$PassiveHealthDrain.start()
		else:
			$PassiveHealthDrain.stop()
		print(powers_toggled)
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		_handle_attack_combo()
	move_and_slide()


func _handle_attack_combo():
	$AttackHitboxes/Attack1.monitoring = true
	$AttackHitboxes/Attack1/CollisionShape2D.disabled = false
	
	await get_tree().create_timer(0.2).timeout
	
	$AttackHitboxes/Attack1.monitoring = false
	$AttackHitboxes/Attack1/CollisionShape2D.disabled = true
	
func _on_passive_health_drain_timeout() -> void:
	curr_hp = curr_hp - 1


func _on_attack_1_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(10)
