extends Control

onready var main: VBoxContainer = $VBoxContainer 
onready var optionpanel = $optionpanel

var scenepath = "res://scenes/"

func _ready() -> void:
	optionpanel.hide()
	OS.window_fullscreen = true

func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene("res://scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed():
	optionpanel.show()

func _on_back_pressed() -> void:
	optionpanel.hide() 

func _on_MuteCheckBox_toggled(button_pressed: bool) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, button_pressed)

func _on_VolumeSlider_value_changed(value: float) -> void:
	var master_bus = AudioServer.get_bus_index("Master")
	
	# linear2db converts our slider's 0.0 to 1.0 range into decibels
	# If the value hits 0, it drops the dB so low it mutes completely
	if value == 0:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
		AudioServer.set_bus_volume_db(master_bus, linear2db(value))



