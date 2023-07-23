extends Node2D

signal result(won, rarity)
signal exit
signal rolling_dice

var globals = preload("res://globals.gd")

@export var win_count_condition = 3

enum State {
	INIT, 
	CHOOSE_DICE,
	ROLL,
	ROLLING,
	PAYOUT,
	END
}
var state = State.INIT

var player_die: Array

var player_won = 0
var fish_won = 0

# These are logic variables to collect information about the current roll only
# Since they are collected via signals, we need to be careful
var player_rolling = false
var fish_rolling = false
var player_rolled = 0
var fish_rolled = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	clean_controls()
	$Fisherman.initialise_gambling()
	$AnimationPlayer.play("ease_in_gambling_screen")
	update_name_labels()
	
	
func clean_controls():
	$HUD/HUDControl/ChooseDiceControl.hide()
	$HUD/HUDControl/RollControl.hide()


func choose_dice():
	state = State.CHOOSE_DICE
	clean_controls()
	$HUD/HUDControl/ChooseDiceControl.set_fish_choice($GamblingFish.dice)
	$HUD/HUDControl/ChooseDiceControl.show()
	
func show_end():
	$HUD/HUDControl/RollControl/Panel/RollButton.text = "EXIT"
	
func set_roll_status(text):
	$HUD/HUDControl/RollControl/Panel/Status.text = text
	
func play_dice():
	state = State.ROLL
	clean_controls()
	set_roll_status("")
	$HUD/HUDControl/RollControl/Panel/PlayerDie.set_values(player_die)
	$HUD/HUDControl/RollControl/Panel/FishDie.set_values($GamblingFish.dice)
	$HUD/HUDControl/RollControl.show()
	
func roll():
	rolling_dice.emit()
	player_rolling = true
	fish_rolling = true
	state = State.ROLLING
	$HUD/HUDControl/RollControl/Panel/PlayerDie.roll()
	$HUD/HUDControl/RollControl/Panel/FishDie.roll()
	
func handle_rolled():
	if player_rolled > fish_rolled:
		player_won += 1
		set_roll_status("You won this roll!")
	elif player_rolled < fish_rolled:
		fish_won += 1
		set_roll_status("Fish won this roll!")
	else:
		set_roll_status("DRAW!")
	
	update_name_labels()
	
	state = State.ROLL
	if player_won == win_count_condition:
		set_roll_status("You won! +1 " + $GamblingFish.rarity.capitalize() + " Fish")
		result.emit(true, $GamblingFish.rarity)
		state = State.END
		show_end()
	elif fish_won == win_count_condition:
		set_roll_status("You lost! -1 " + $GamblingFish.rarity.capitalize() + " Fish")
		result.emit(false, $GamblingFish.rarity)
		state = State.END
		show_end()
	
	
func update_name_labels():
	var player_label_text = "Player "
	for i in range(player_won):
		player_label_text += "+"
	
	var fish_label_text = " " + $GamblingFish.rarity.capitalize() + " Fish"
	for i in range(fish_won):
		fish_label_text = "+" + fish_label_text
		
	$HUD/HUDControl/PlayerLabel.text = player_label_text
	$HUD/HUDControl/FishLabel.text = fish_label_text
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ease_in_gambling_screen" and state == State.INIT:
		choose_dice()
		


func _on_pick_a_pressed():
	if state == State.CHOOSE_DICE:
		player_die = globals.DICE_MAP["A"]
		play_dice()


func _on_pick_b_pressed():
	if state == State.CHOOSE_DICE:
		player_die = globals.DICE_MAP["B"]
		play_dice()


func _on_pick_c_pressed():
	if state == State.CHOOSE_DICE:
		player_die = globals.DICE_MAP["C"]
		play_dice()


func _on_roll_button_pressed():
	if state == State.ROLL:
		roll()
	elif state == State.END:
		exit.emit()


func _on_player_die_rolled(value: int):
	if state == State.ROLLING:
		player_rolling = false
		player_rolled = value
		if !player_rolling and !fish_rolling:
			handle_rolled()




func _on_fish_die_rolled(value: int):
	if state == State.ROLLING:
		fish_rolling = false
		fish_rolled = value
		if !player_rolling and !fish_rolling:
			handle_rolled()
