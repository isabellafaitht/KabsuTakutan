extends Control

func _input(event: InputEvent) -> void:
	# "ui_accept" is Godot's default built-in action for Spacebar and Enter.
	if event.is_action_pressed("ui_accept"):
		# Put the exact path to your User Interface scene here
		get_tree().change_scene("res://scenes/UserInterface.tscn")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
