extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var warning_label = $"../Player/BoundaryUI/Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_BoundaryTrigger_body_entered(body):
	if body.name == "Player":
		warning_label.visible = true

func _on_BoundaryTrigger_body_exited(body):
	if body.name == "Player":
		warning_label.visible = false
