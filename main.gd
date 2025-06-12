extends Node

@export var mob_scene: PackedScene
@export var boom: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func booms():
	var sound = $"boomsound"
	sound.position = $"Player".global_position
	if boom == null:
		print("Explosion scene not assigned")
		return

	var particle = boom.instantiate()
	if particle == null:
		print("Failed to instantiate explosion")
		return

	particle.position = $"Player".global_position
	add_child(particle)
	sound.play()
	# Если это Particle2D, можно вручную включить эмиттер
	particle.emitting = true

func game_over():
	booms()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$joy.visible = false
	print("game Over!")

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Приготовьтесь!")
	$Player.start($StartPosition.position)
	$joy.visible = true
	$StartTimer.start()
	print("newGame!")
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	print("_on_mob_timer_timeout!")
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_hud_start_game() -> void:
	new_game()


func _on_player_hit() -> void:
	game_over()
