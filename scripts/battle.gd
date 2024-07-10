extends Node2D

var coin_tosses_left = 5
@onready var animated_sprite_2d = $Outcome/AnimatedSprite2D
@onready var outcome_label = $Outcome/OutcomeLabel
@onready var outcome_history = $VBoxContainer/HBoxContainer/OutcomeHistory
@onready var button1 = $Button
@onready var button2 = $Button2
@onready var button3 = $Button3
@onready var boss_hp = $Enemy/BossHPBar
@onready var coin_toss_button = $CoinTossButton
@onready var label = $CoinTossButton/Label
var button1_should_be_disabled = false
var button2_should_be_disabled = false
var button3_should_be_disabled = false

func _ready():
	update_buttons()
	
func _on_coin_toss_button_pressed():
	coin_tosses_left -= 1
	label.text = str(coin_tosses_left) + " / 5"
	animated_sprite_2d.play("default")
	var outcome = flip_coin()
	outcome_label.text = outcome
	update_outcome_history()
	update_buttons()

func flip_coin() -> String:
	var rand_num = randi() % 2
	var outcome = "Heads" if rand_num == 0 else "Tails"
	Global.add_outcome(outcome)
	return outcome

func update_outcome_history():
	var text = "Last Outcomes: "
	# Loop through the outcomes from the last to the first
	for i in range(min(Global.outcomes.size(), 5)):
		if i > 0:
			text += " - "  # This adds the separator before adding the next outcome
		text += Global.outcomes[Global.outcomes.size() - 1 - i]  # Start from the last element
	outcome_history.text = text

func update_buttons():
	# Check if the recent outcomes match the required sequences for each button.
	coin_toss_button.disabled = coin_tosses_left <= 0
	label.text = str(coin_tosses_left) + " / 5"
	if button1_should_be_disabled:
		button1.disabled = true
	else:
		button1.disabled = not has_recent_sequence(["Heads"])
		
	if button2_should_be_disabled:
		button2.disabled = true
	else:
		button2.disabled = not has_recent_sequence(["Heads", "Heads"])
	
	if button3_should_be_disabled:
		button3.disabled = true
	else:
		button3.disabled = not has_recent_sequence(["Heads", "Heads", "Heads"])

func has_recent_sequence(sequence: Array) -> bool:
	# This function checks if the most recent outcomes match the given sequence.
	var count = sequence.size()
	if Global.outcomes.size() < count:
		return false
	for i in range(count):
		if Global.outcomes[i] != sequence[count - i - 1]:
			return false
	return true


func _on_button_pressed():
	boss_hp.value -= 5
	button1_should_be_disabled = true
	update_buttons()


func _on_button_2_pressed():
	boss_hp.value -= 15
	button2_should_be_disabled = true
	update_buttons()


func _on_button_3_pressed():
	boss_hp.value -= 25
	button2_should_be_disabled = true
	update_buttons()


func _on_end_turn_pressed():
	$Player/PlayerHPBar.value -= 10
	coin_tosses_left = 5
	Global.outcomes = []
	outcome_history.text = "Last Outcomes: "
	button1_should_be_disabled = false
	button2_should_be_disabled = false
	button3_should_be_disabled = false
	update_buttons()
