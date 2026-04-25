extends Area

# This loads your saved enemy file into memory, ready to be created
# (Double check that this file path perfectly matches your project!)
var enemy_scene = preload("res://scenes/GhostFaculty.tscn")
var player: Spatial = null

func _on_spawntrap_body_entered(body):
	if body.name == "Player":
		var ghost_scene = preload("res://scenes/GhostFaculty.tscn")
		var ghost = ghost_scene.instance()
		
		get_parent().add_child(ghost)
		
		ghost.player = body 
		
		# 1. Set her position to the trap's spawn point
		ghost.global_transform.origin = $Position3D.global_transform.origin
		
		# --- NEW CODE: SNAP HER ATTENTION TO THE PLAYER ---
		# 2. Force her to look exactly where the player is standing
		ghost.look_at(body.global_transform.origin, Vector3.UP)
		
		# 3. Flatten her rotation so she doesn't tilt into the floor or sky 
		# (This keeps her standing perfectly straight up)
		ghost.rotation.x = 0
		ghost.rotation.z = 0
		# --------------------------------------------------
		
		$CollisionShape.set_deferred("disabled", true)
