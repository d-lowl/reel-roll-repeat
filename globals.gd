extends Node

const DICE_MAP: Dictionary = {
	"A": [1, 1, 3, 5, 6, 5],
	"B": [2, 3, 4, 3, 5, 4],
	"C": [1, 2, 6, 2, 4, 6]
}

static func get_random_die(buff: float) -> Array:
	var keys = DICE_MAP.keys()
	var die = DICE_MAP[keys[randi_range(0, keys.size() - 1)]].duplicate()
	for i in range(die.size()):
		if randf() < buff:
			die[i] = clamp(die[i] + 1, 1, 6)
			
	return die
