extends Control

var globals = preload("res://globals.gd")

func _ready():
	$ChooseDicePanel/UnwrappedDiceA.set_dice("red", globals.DICE_MAP["A"])
	$ChooseDicePanel/UnwrappedDiceB.set_dice("red", globals.DICE_MAP["B"])
	$ChooseDicePanel/UnwrappedDiceC.set_dice("red", globals.DICE_MAP["C"])

func set_fish_choice(values: Array):
	$FishPickedPanel/UnwrappedDiceFish.set_dice("green", values)
