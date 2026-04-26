extends KinematicBody

# In Godot 3, it's safer to export a NodePath and get the node in _ready
export(NodePath) var player_path
export var min_teleport_dist: float = 4.0
export var max_teleport_dist: float = 12.0
export var move_speed: float = 5.0
export var fov_threshold: float = 0.5 
onready var scream_timer: Timer = $ScreamTimer
onready var player: Spatial = get_node(player_path)
onready var raycast: RayCast = $RayCast
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var teleport_timer: Timer = $TeleportTimer

var is_being_looked_at: bool = false
var velocity: Vector3 = Vector3.ZERO

func _ready():
	# Godot 3 uses string-based signal connections
	teleport_timer.connect("timeout", self, "_on_teleport_timer_timeout")
	raycast.add_exception(self)
	
	# Create a 10-second countdown timer in the background
	var despawn_timer = get_tree().create_timer(15.0)
	
		# When the 10 seconds are up, call the queue_free function to delete her
	despawn_timer.connect("timeout", self, "queue_free")
	
	$Scream.play()
	
	# 2. CREATE A 2-SECOND TIMER IN THE BACKGROUND
	var scream_timer = get_tree().create_timer(3.0)
	
	# 3. TELL THE TIMER TO "STOP" THE AUDIO WHEN TIME IS UP
	scream_timer.connect("timeout", $Scream, "stop")

func _physics_process(delta):
	if not player:
		return

	check_player_vision()

	if is_being_looked_at:
		# SLENDRINA IS SEEN
		velocity = Vector3.ZERO
	else:
		# SLENDRINA IS UNSEEN
		var dir_to_player = global_transform.origin.direction_to(player.global_transform.origin)
		velocity = dir_to_player * move_speed
		
		# Make her face the player
		look_at(player.global_transform.origin, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
		
		
		anim_player.play("mixamocom")
		anim_player.playback_speed = 2.0
		print("Looked at: ", is_being_looked_at, " | Speed: ", velocity)
	# Godot 3 requires you to pass velocity and the UP vector
	velocity = move_and_slide(velocity, Vector3.UP)

func check_player_vision():
	var dir_to_monster = player.global_transform.origin.direction_to(global_transform.origin)
	var player_forward = -player.global_transform.basis.z.normalized()
	var dot_product = player_forward.dot(dir_to_monster)
	
	if dot_product > fov_threshold:
		# In Godot 3, RayCast uses cast_to instead of target_position
		raycast.cast_to = raycast.to_local(player.global_transform.origin)
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider == player:
				is_being_looked_at = true
			else:
				is_being_looked_at = false
		else:
			is_being_looked_at = true
	else:
		is_being_looked_at = false

func _on_teleport_timer_timeout():
	if not is_being_looked_at:
		teleport_behind_player()

func teleport_behind_player():
	var player_backward = player.global_transform.basis.z.normalized()
	var random_dist = rand_range(min_teleport_dist, max_teleport_dist)
	
	var new_position = player.global_transform.origin + (player_backward * random_dist)
	new_position.y = global_transform.origin.y 
	
	global_transform.origin = new_position
	
	look_at(player.global_transform.origin, Vector3.UP)
	rotation.x = 0
	rotation.z = 0


func _on_Killzone_body_entered(body):
	if body.name == "Player":
		get_tree().call_deferred("change_scene", "res://scenes/Gameover.tscn")
