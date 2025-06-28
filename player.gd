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


	#if Input.is_action_just_pressed("toggle_powers"):
		#
		#powers_toggled = not powers_toggled
		#if (powers_toggled):
			#$PassiveHealthDrain.start()
		#else:
			#$PassiveHealthDrain.stop()
		#print(powers_toggled)
	#
	#if Input.is_action_just_pressed("attack") and is_on_floor():
		#_handle_attack_combo()
	move_and_slide()

@onready var attackAnims = $AttackAnimations
var comboHit = 1
var comboQueued = false
var hit_targets := {}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_powers"):
		powers_toggled = not powers_toggled
		if (powers_toggled):
			$PassiveHealthDrain.start()
		else:
			$PassiveHealthDrain.stop()
		print(powers_toggled)
	
	if event.is_action_pressed("attack") and is_on_floor():
		print("hello??")
		if (attackAnims.is_playing()):
			print("huh")
			if (attackAnims.current_animation != "Combo"):
				print("L")
				return
			else:
				print("nide mama")
				comboQueued = true
		print("hrm")
		hit_targets.clear()
		_handle_attack_combo()
				
		
		

func _handle_attack_combo():
	if comboQueued:
		attackAnims.stop(false)
	var anim_name = "Attack%d" % comboHit
	print(anim_name)
	attackAnims.play(anim_name)
	
func _on_passive_health_drain_timeout() -> void:
	curr_hp = curr_hp - 1


func _on_attack_1_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(10)

func _on_attack_2_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(15)


func _on_attack_3_body_entered(body: Node2D) -> void:
	if body is Enemy and not hit_targets.has(body):
		hit_targets[body] = true
		body.take_damage(25)
	
	
func _on_attack_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("Attack"):
		if comboHit < 3:
			comboHit += 1
			attackAnims.play("Combo")
		elif comboHit >= 3:
			comboHit = 1
	elif anim_name == "Combo":
		comboHit = 1
