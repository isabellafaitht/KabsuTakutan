extends StaticBody

var is_open: bool = false
onready var anim_player = $AnimationPlayer

# This is the exact function the Player script looks for!
func interact():
	if is_open:
		# If it's already open, close it
		anim_player.play("close")
		is_open = false
	else:
		# If it's closed, open it
		anim_player.play("open")
		is_open = true
		
		# Optional: Play a creaky door sound here!
		# $AudioStreamPlayer3D.play()




