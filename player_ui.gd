extends CanvasLayer

@export var player: Player
var maxhealth
var currhealth
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxhealth = player.max_hp
	currhealth = player.curr_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _process(delta: float) -> void:
	currhealth = player.curr_hp
	var percentage = float(currhealth) / maxhealth
	
	var full_width = $Control/HealthBG.size.x
	$Control/HealthBG/Health.size.x = full_width * percentage
