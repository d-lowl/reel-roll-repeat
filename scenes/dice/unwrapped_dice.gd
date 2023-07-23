extends Node2D

@export var colour: String = "green"
@export var side_values: Array = [1, 2, 3, 4, 5, 6]
var faces: Array


func _ready():
	faces = [
		$Face1,
		$Face2,
		$Face3,
		$Face4,
		$Face5,
		$Face6
	]
	redraw()
	
func set_dice(_colour: String, _side_values: Array):
	colour = _colour
	side_values = _side_values.duplicate() 
	redraw()

func redraw():
	for i in range(6):
		var face = faces[i]
		face.colour = colour
		face.value = side_values[i]
		face.redraw()
