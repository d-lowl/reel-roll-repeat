extends Node2D

# Define all screens we want to use
const SeaScreen = preload("res://scenes/sea/sea_screen.tscn")
const GamblingScreen = preload("res://scenes/gambling/gambling_screen.tscn")

const RARITY_ORDER = [
	"common",
	"uncommon",
	"rare",
	"epic",
	"legendary"
]

# Game stats
var score: int = 0
var fish_caught = {
	"common": 10,
	"uncommon": 2,
	"rare": 1,
	"epic": 0,
	"legendary": 0,
}
var lost: bool = false

enum State {
	FISHING,
	GAMBLING
}

var state: State

# Called when the node enters the scene tree for the first time.
func _ready():
	switch_to_fishing(false)
	update_score_panel()
	
func clean_screens():
	var screen_names = [
		"GamblingScreen",
		"SeaScreen"
	]
	for i in range(screen_names.size()):
		if has_node(screen_names[i]):
			get_node(screen_names[i]).queue_free()
	
func switch_to_fishing(is_game_over):
	state = State.FISHING
	clean_screens()
	var sea_screen = SeaScreen.instantiate()
	sea_screen.caught.connect(_on_sea_screen_caught)
	if is_game_over:
		sea_screen.game_over_flag = true
	add_child(sea_screen)
	


func switch_to_gambling(rarity: String, dice: Array):
	state = State.GAMBLING
	clean_screens()
	var gambling_screen = GamblingScreen.instantiate()
	var fish = gambling_screen.get_node("GamblingFish")
	fish.rarity = rarity
	fish.dice = dice
	gambling_screen.result.connect(_on_gambling_screen_result)
	gambling_screen.exit.connect(_on_gambling_screen_exit)
	gambling_screen.rolling_dice.connect($DiceRollingEffect.on_dice_roll)
	add_child(gambling_screen)

func _on_sea_screen_caught(rarity, dice):
	if state == State.FISHING:
		switch_to_gambling(rarity, dice)
		
func add_fish(rarity):
	fish_caught[rarity] += 1
	var order = RARITY_ORDER.find(rarity)
	score += 2 ** order
	
func remove_fish(rarity: String):
	var order = RARITY_ORDER.find(rarity)
	# Base case, we have a fish of this rarity
	if fish_caught[rarity] >= 1:
		fish_caught[rarity] -= 1
		return
	else:
		for i in range(order, RARITY_ORDER.size()):
			# If we have a fish of higher rarity, we pay with that
			if fish_caught[RARITY_ORDER[i]] >= 1:
				fish_caught[RARITY_ORDER[i]] -= 1
				return
		
		# We cannot pay, we lost
		lost = true
		
func _on_gambling_screen_result(won: bool, rarity: String):
	if won:
		add_fish(rarity)
	else:
		remove_fish(rarity)
	update_score_panel()

func game_over_screen():
	$HUD/GameOverPanel.show()
	
	
func _on_gambling_screen_exit():
	if state == State.GAMBLING:
		switch_to_fishing(lost)
		if lost:
			game_over_screen()
			
func update_score_panel():
	$HUD/ScorePanel/ScoreCount.text = str(score)
	$HUD/ScorePanel/CommonCount.text = str(fish_caught["common"])
	$HUD/ScorePanel/UncommonCount.text = str(fish_caught["uncommon"])
	$HUD/ScorePanel/RareCount.text = str(fish_caught["rare"])
	$HUD/ScorePanel/EpicCounter.text = str(fish_caught["epic"])
	$HUD/ScorePanel/LegendaryCounter.text = str(fish_caught["legendary"])
