extends Panel

onready var singlePlayer = $MarginContainer/HBoxContainer/VBoxContainer/MenuOptions/SinglePlayer
onready var backgroundMusic = $BackgroundMusic

#TODO: Intalize the current leaderboards of the game and display them
func _ready():
	singlePlayer.grab_focus()
	backgroundMusic.play()


#TODO: Start the game in single player mode
func _on_SinglePlayer_pressed():
	pass # Replace with function body.


#TODO: Start the game in multiplayer mode
func _on_Multiplayer_pressed():
	pass # Replace with function body.


#TODO: open an Options scene
func _on_Options_pressed():
	pass # Replace with function body.


# Loops the background music so it never stops playing
func _on_BackgroundMusic_finished():
	backgroundMusic.play()
