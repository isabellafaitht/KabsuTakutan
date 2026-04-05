extends Area

# This loads your saved enemy file into memory, ready to be created
# (Double check that this file path perfectly matches your project!)
var enemy_scene = preload("res://mois-moving.tscn")

func _on_spawntrap_body_entered(body):
	if body.name == "Player":
		print("Trap triggered! Spawning enemy...")
		
		# 1. Create a brand new copy of the enemy
		var new_enemy = enemy_scene.instance()
		
		# 2. Add the enemy into the main game world
		# get_parent() ensures it is added to the same level as the Player
		get_parent().add_child(new_enemy)
		
		# 3. Teleport the new enemy to the Position3D's exact location
		new_enemy.global_transform.origin = $Position3D.global_transform.origin
		
		# 4. Destroy the trap so it only spawns ONE enemy, not an infinite army!
		queue_free()
