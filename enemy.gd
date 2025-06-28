extends CharacterBody2D
class_name Enemy

@export var speed: float = 150.0
@export var maxhealth: float = 20.0
var currhealth: float = maxhealth

var direction := -1  # -1 = left, 1 = right
const GRAV = 2000.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAV * delta
		
	velocity.x = direction * speed
	move_and_slide()

	# Check if we hit something on the left or right
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		# If we hit a wall (left or right)
		if normal.x != 0:
			direction *= -1
			break

func take_damage(damage: float):
	currhealth -= damage
	var percentage = float(currhealth) / maxhealth
	
	var full_width = $EnemyUI/HealthBG.size.x
	$EnemyUI/HealthBG/Health.size.x = full_width * percentage
	if (currhealth <= 0):
		queue_free()
