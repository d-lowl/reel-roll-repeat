extends Node2D

signal rolled(value)

@export var roll_count: int = 20
@export var values = [1, 2, 3, 4, 5, 6]
@export var colour: String = "green"
var left_to_roll: int
var value: int = 1

func show_number(number: int):
	$AnimatedSprite2D.frame = number - 1

# Called when the node enters the scene tree for the first time.
func _ready():
	redraw()


func roll():
	left_to_roll = roll_count
	$RollTimer.start()


func _on_roll_timer_timeout():
	left_to_roll -= 1
	value = values[randi_range(0, 5)]
	show_number(value)
	if left_to_roll <= 0:
		$RollTimer.stop()
		rolled.emit(value)
		
func redraw():
	$AnimatedSprite2D.animation = colour
	show_number(value)
	
func set_values(new_values: Array):
	values = new_values
	value = values[0]
	redraw()
	
