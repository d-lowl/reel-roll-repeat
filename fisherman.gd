extends Node2D

signal caught(rarity: String, dice: Array)

@export var line_length = 100
@export var reeling_speed = 300
var pole_point_position: Vector2
var hook_position: Vector2
var caught_fish

enum State {GAMBLING, AIMING, SHOOTING, REELING, GAME_OVER}
var state = State.AIMING

# Called when the node enters the scene tree for the first time.
func _ready():
	pole_point_position = $FishingLine.get_point_position(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.GAMBLING or state == State.GAME_OVER:
		return
	
	if state == State.AIMING:
		var mouse_position = get_viewport().get_mouse_position()
		hook_position = pole_point_position + (mouse_position - pole_point_position).normalized() * line_length
	elif state == State.SHOOTING:
		hook_position += (hook_position - pole_point_position).normalized() * reeling_speed * delta
	elif state == State.REELING:
		hook_position -= (hook_position - pole_point_position).normalized() * reeling_speed * delta
		
	$Hook.position = hook_position
	$FishingLine.clear_points()
	$FishingLine.add_point(pole_point_position, 0)
	$FishingLine.add_point(hook_position, 1)
	
	if state == State.REELING:
		caught_fish.position = hook_position
		caught_fish.rotation = - PI / 2
		if (hook_position - pole_point_position).length() <= line_length:
			# Finished cycle
			caught_fish.queue_free()
			caught.emit(caught_fish.rarity, caught_fish.dice)
			caught_fish = null
			state = State.AIMING
	
func _input(event):
	if state == State.AIMING and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		state = State.SHOOTING


func _on_visible_on_screen_notifier_2d_screen_exited():
	# Did not catch anything
	state = State.AIMING


func _on_hook_area_2d_body_entered(fish):
	if state == State.SHOOTING:
		state = State.REELING
		fish.die()
		caught_fish = fish
		
func initialise_gambling():
	state = State.GAMBLING
