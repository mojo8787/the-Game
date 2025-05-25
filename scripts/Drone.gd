extends CharacterBody2D

@export var hover_speed: float = 50.0
@export var patrol_speed: float = 80.0
@export var chase_speed: float = 120.0
@export var hover_amplitude: float = 15.0
@export var hover_frequency: float = 2.0
@export var patrol_distance: float = 200.0
@export var detection_range: float = 80.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var thruster_particles: GPUParticles2D = $ThrusterParticles
@onready var scan_beam: Line2D = $ScanBeam
@onready var movement_timer: Timer = $MovementTimer
@onready var scan_timer: Timer = $ScanTimer
var hover_tween: Tween
var rotation_tween: Tween
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

enum DroneState {
	HOVERING,
	PATROLLING,
	SCANNING,
	CHASING,
	RETURNING
}

var current_state: DroneState = DroneState.HOVERING
var player_detected: bool = false
var player_reference: Node = null
var start_position: Vector2
var patrol_target: Vector2
var hover_time: float = 0.0
var scan_angle: float = 0.0
var movement_direction: Vector2 = Vector2.ZERO

# Movement patterns
var patrol_points: Array[Vector2] = []
var current_patrol_index: int = 0

func _ready():
	start_position = global_position
	
	setup_patrol_points()
	start_hover_animation()
	start_thruster_effects()
	
	# Add to enemy group for player collision detection
	add_to_group("enemy")
	
	print("Drone initialized at position: ", start_position)

func setup_patrol_points():
	# Create a patrol pattern around the starting position
	patrol_points = [
		start_position + Vector2(-patrol_distance, 0),
		start_position + Vector2(0, -patrol_distance),
		start_position + Vector2(patrol_distance, 0),
		start_position + Vector2(0, patrol_distance)
	]

func _physics_process(delta: float) -> void:
	hover_time += delta
	
	# Handle state-based behavior
	match current_state:
		DroneState.HOVERING:
			handle_hovering(delta)
		DroneState.PATROLLING:
			handle_patrolling(delta)
		DroneState.SCANNING:
			handle_scanning(delta)
		DroneState.CHASING:
			handle_chasing(delta)
		DroneState.RETURNING:
			handle_returning(delta)
	
	# Apply hover effect to all states
	apply_hover_effect(delta)
	
	# Update visual effects
	update_visual_effects()
	
	move_and_slide()

func handle_hovering(delta: float):
	animated_sprite.play("hover")
	velocity = Vector2.ZERO
	
	# Slight random movement for more natural hovering
	if randf() < 0.01:  # 1% chance per frame
		movement_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = movement_direction * hover_speed * 0.3

func handle_patrolling(delta: float):
	animated_sprite.play("flying")
	
	var target = patrol_points[current_patrol_index]
	var direction = (target - global_position).normalized()
	velocity = direction * patrol_speed
	
	# Face movement direction
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Check if reached patrol point
	if global_position.distance_to(target) < 20:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

func handle_scanning(delta: float):
	animated_sprite.play("scanning")
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta)
	
	# Rotate scan beam
	scan_angle += delta * 180  # 180 degrees per second
	var beam_direction = Vector2.from_angle(deg_to_rad(scan_angle))
	scan_beam.points[1] = beam_direction * 60
	
	# Make scan beam visible
	scan_beam.visible = true

func handle_chasing(delta: float):
	if player_reference:
		animated_sprite.play("flying")
		var direction = (player_reference.global_position - global_position).normalized()
		velocity = direction * chase_speed
		
		# Face player
		if direction.x != 0:
			animated_sprite.flip_h = direction.x < 0
		
		# Increase thruster intensity
		thruster_particles.amount = 40
	else:
		change_state(DroneState.RETURNING)

func handle_returning(delta: float):
	animated_sprite.play("flying")
	var direction = (start_position - global_position).normalized()
	velocity = direction * patrol_speed
	
	# Face movement direction
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	
	# Check if returned to start
	if global_position.distance_to(start_position) < 30:
		change_state(DroneState.HOVERING)

func apply_hover_effect(delta: float):
	# Add subtle up/down floating motion
	var hover_offset = sin(hover_time * hover_frequency) * hover_amplitude * 0.5
	position.y += hover_offset * delta

func change_state(new_state: DroneState):
	# Exit current state
	match current_state:
		DroneState.SCANNING:
			scan_beam.visible = false
		DroneState.CHASING:
			thruster_particles.amount = 25
	
	current_state = new_state
	print("Drone state changed to: ", DroneState.keys()[new_state])
	
	# Enter new state
	match new_state:
		DroneState.PATROLLING:
			movement_timer.wait_time = randf_range(3.0, 6.0)
			movement_timer.start()
		DroneState.SCANNING:
			scan_angle = 0.0
			movement_timer.wait_time = 3.0
			movement_timer.start()

func start_hover_animation():
	# Create smooth up-down hovering motion
	hover_tween = create_tween()
	hover_tween.set_loops()
	var hover_offset = hover_amplitude
	hover_tween.tween_method(
		func(offset): position.y = start_position.y + offset,
		-hover_offset,
		hover_offset,
		2.0
	)
	hover_tween.set_trans(Tween.TRANS_SINE)
	hover_tween.set_ease(Tween.EASE_IN_OUT)

func start_thruster_effects():
	if thruster_particles:
		thruster_particles.emitting = true
		# Add slight rotation to make it more dynamic
		rotation_tween = create_tween()
		rotation_tween.set_loops()
		rotation_tween.tween_property(animated_sprite, "rotation", deg_to_rad(5), 2.0)
		rotation_tween.tween_property(animated_sprite, "rotation", deg_to_rad(-5), 2.0)
		rotation_tween.set_trans(Tween.TRANS_SINE)

func update_visual_effects():
	# Adjust particle intensity based on movement
	var speed_factor = velocity.length() / chase_speed
	if thruster_particles and thruster_particles.process_material:
		# Access the scale property through the process material
		var material = thruster_particles.process_material as ParticleProcessMaterial
		if material:
			material.scale_min = 0.2 + speed_factor * 0.3
			material.scale_max = 0.5 + speed_factor * 0.5
	
	# Update scan beam visibility
	if current_state == DroneState.SCANNING:
		scan_beam.default_color.a = 0.6 + sin(hover_time * 4) * 0.2

func _on_detection_area_body_entered(body: Node) -> void:
	if body.has_method("_physics_process") and body != self:
		print("Player detected by drone!")
		player_detected = true
		player_reference = body
		change_state(DroneState.SCANNING)

func _on_detection_area_body_exited(body: Node) -> void:
	if body == player_reference:
		print("Player lost by drone!")
		player_detected = false
		player_reference = null
		change_state(DroneState.RETURNING)

func _on_movement_timer_timeout() -> void:
	match current_state:
		DroneState.HOVERING:
			# Randomly choose next action
			var rand = randf()
			if rand < 0.6:
				change_state(DroneState.PATROLLING)
			else:
				change_state(DroneState.SCANNING)
		
		DroneState.PATROLLING:
			change_state(DroneState.HOVERING)
		
		DroneState.SCANNING:
			if player_detected:
				change_state(DroneState.CHASING)
			else:
				change_state(DroneState.HOVERING)

func _on_scan_timer_timeout() -> void:
	# Create scanning audio effect
	if audio and current_state == DroneState.SCANNING:
		audio.pitch_scale = randf_range(1.0, 1.5)
		# Would need actual audio file - for now just pitch variation

# Utility function for other objects to interact with drone
func alert_drone(alert_position: Vector2):
	"""Call this to make the drone investigate a specific position"""
	patrol_target = alert_position
	change_state(DroneState.PATROLLING)

func disable_drone():
	"""Call this to disable the drone (e.g., when destroyed)"""
	change_state(DroneState.HOVERING)
	thruster_particles.emitting = false
	animated_sprite.modulate = Color.GRAY 
