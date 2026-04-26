extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_menu()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_pressed():
	toggle_menu()

func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/UserInterface.tscn")

func _on_MuteCheckBox_toggled(button_pressed):
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, button_pressed)

func _on_VolumeSlider_value_changed(value):
	var master_bus = AudioServer.get_bus_index("Master")
	
	# linear2db converts our slider's 0.0 to 1.0 range into decibels
	# If the value hits 0, it drops the dB so low it mutes completely
	if value == 0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, linear2db(value))
