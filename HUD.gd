extends CanvasLayer


# Notifies Main node that the button has been pressed
signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	# Wait until MessageTime has counted down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\ncreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish
	# Do this by getting access to the scene tree and
	# creating a custom one-shot timer
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	# Send the 'start_game' signal for anyone listening
	# for it
	start_game.emit()
