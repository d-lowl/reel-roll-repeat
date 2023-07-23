extends Node2D

signal caught(rarity: String, dice: Array)

var screen_size
@export var fish_scene: PackedScene
@export var base_fish_speed: float
@export var game_over_flag: bool = false

func spawn_fish():
	var is_right_of_screen = randf() > 0.5
	var top_spawn = $Spawn/TopSpawnMarker.position.y
	var bottom_spawn = $Spawn/BottomSpawnMarker.position.y
	var spawn_height = bottom_spawn - top_spawn
	var point = Vector2(
		screen_size.x if is_right_of_screen else 0.0,
		top_spawn + spawn_height * randf()
	)
	
	var fish = fish_scene.instantiate()
	fish.linear_velocity = Vector2(((-1 if is_right_of_screen else 1) + randf_range(-0.25, 0.25)) * base_fish_speed, 0)
	fish.position = point
	fish.init()
	add_child(fish)
	

func game_over():
	$Fisherman.initialise_gambling()
	


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$FishSpawnTimer.start()
	spawn_fish()
	if game_over_flag:
		game_over()


func _on_fish_spawn_timer_timeout():
	spawn_fish()


func _on_fisherman_caught(rarity, dice):
	caught.emit(rarity, dice)
	hide()
