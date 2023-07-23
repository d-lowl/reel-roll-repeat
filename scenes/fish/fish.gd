extends RigidBody2D
class_name Fish

var globals = preload("res://globals.gd")

const RARITY_MAP = {
	"common": 30,
	"uncommon": 9,
	"rare": 3,
	"epic": 2,
	"legendary": 1
}

const RARITY_BUFF_MAP = {
	"common": 0.0,
	"uncommon": 1.0 / 6.0,
	"rare": 1.5 / 6.0,
	"epic": 2.0 / 6.0,
	"legendary": 3.0 / 6.0
}

@export var rarity: String
@export var dice: Array

func find_rarity() -> String:
	var total_rarity = 0
	for _rarity in RARITY_MAP:
		total_rarity += RARITY_MAP[_rarity]
	var p = randf() * total_rarity
	var running_total = 0
	for _rarity in RARITY_MAP:
		running_total += RARITY_MAP[_rarity]
		if p <= running_total:
			return _rarity
	return "legendary"


# Called when the node enters the scene tree for the first time.
func _ready():
	rarity = find_rarity()
	$AnimatedSprite2D.animation = rarity
	dice = globals.get_random_die(RARITY_BUFF_MAP[rarity])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func init():
	$AnimatedSprite2D.flip_h = linear_velocity.x < 0.0



func die():
	$AnimatedSprite2D.flip_h = false
	linear_velocity = Vector2.ZERO



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
