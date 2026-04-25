extends KinematicBody 

var speed = 2.5
var player = null
var velocity = Vector3.ZERO 

# --- NEW TIMER VARIABLES ---
var chase_time = 0.0
var max_chase_time = 20.0 

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta): 
	# --- NEW TIMER LOGIC ---
	# Add the fraction of a second (delta) to our timer every frame
	chase_time += delta
	
	# Check if 20 seconds have passed
	if chase_time >= max_chase_time:
		print("Time is up! Enemy is leaving.")
		queue_free() # This safely deletes the enemy from the game
		return # This stops the rest of the movement code from running this frame

	# --- ORIGINAL MOVEMENT LOGIC ---
	if player != null:
		var target_position = player.global_transform.origin
		var my_position = global_transform.origin
		
		var direction = (target_position - my_position).normalized()
		direction.y = 0 
		direction = direction.normalized()
		
		velocity = direction * speed
		velocity = move_and_slide(velocity, Vector3.UP)


# --- THE KILL ZONE SIGNAL ---
func _on_Killzone_body_entered(body):
	if body.name == "Player":
		print("Nahuli ka!")
		get_tree().call_deferred("change_scene", "res://scenes/Gameover.tscn")
