extends Area

var has_triggered: bool = false
onready var anim_player = $"../AnimationPlayer2"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_TriggerArea2_body_exited(body):
	if has_triggered == false:
		
		# 2. Check if the thing that touched the trap is specifically the Player
		if body.name == "Player":
			
			# 3. Lock the trap so it never fires again
			has_triggered = true
			
			# 4. Play the chair animation!
			anim_player.play("tumba")
			
