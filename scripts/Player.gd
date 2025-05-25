extends CharacterBody2D

@export var speed: float = 200.0
@export var run_speed: float = 350.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var acceleration: float = 10.0
@export var friction: float = 10.0

@onready var jump_audio: AudioStreamPlayer = $JumpAudio
@onready var hit_audio: AudioStreamPlayer = $HitAudio
@onready var footstep_audio: AudioStreamPlayer = $FootstepAudio
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var jump_particles: GPUParticles2D = $JumpParticles
@onready var landing_particles: GPUParticles2D = $LandingParticles
@onready var footstep_timer: Timer = $FootstepTimer

var is_running: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_jumping: bool = false
var just_landed: bool = false
var is_moving: bool = false

# Screen shake variables
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var original_camera_offset: Vector2

func _ready():
	# Verify that we have the AnimatedSprite2D node
	if not animated_sprite:
		print("ERROR: AnimatedSprite2D node not found! Make sure the Player scene has an AnimatedSprite2D child node.")
	
	# Store original camera offset
	if camera:
		original_camera_offset = camera.offset

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	
	# Check if running (holding shift or run button)
	is_running = Input.is_action_pressed("ui_accept") or Input.is_action_pressed("run")
	
	# Handle horizontal movement with acceleration/friction
	var target_speed = 0.0
	if dir != 0:
		var current_speed = run_speed if is_running else speed
		target_speed = dir * current_speed
	
	# Apply acceleration or friction
	if dir != 0:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta * 60)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta * 60)

	# Check if just landed
	var was_on_floor = is_on_floor()
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		# Coyote time - grace period after leaving ground
		if was_on_floor:
			coyote_timer = coyote_time
		else:
			coyote_timer -= delta
	else:
		coyote_timer = coyote_time
		if not was_on_floor and velocity.y > 0:
			just_landed = true
			# Screen shake on landing
			add_screen_shake(3.0, 0.1)
			# Landing particles
			if landing_particles:
				landing_particles.restart()

	# Jump buffering - allows pressing jump slightly before landing
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	# Handle jumping with coyote time and jump buffering
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0):
		velocity.y = jump_velocity
		jump_audio.play()
		is_jumping = true
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		# Small screen shake on jump
		add_screen_shake(2.0, 0.05)
		# Jump particles
		if jump_particles:
			jump_particles.restart()

	# Variable jump height - release space early for lower jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	# Update timers
	jump_buffer_timer -= delta
	if jump_buffer_timer < 0:
		jump_buffer_timer = 0

	# Check if still jumping
	if velocity.y >= 0:
		is_jumping = false

	# Handle footstep audio
	var was_moving = is_moving
	is_moving = is_on_floor() and abs(velocity.x) > 10
	
	if is_moving and not was_moving:
		# Start footstep timer
		start_footstep_timer()
	elif not is_moving:
		# Stop footstep timer
		footstep_timer.stop()

	move_and_slide()
	
	# Handle screen shake
	update_screen_shake(delta)
	
	# Handle animations (only if we have the animated sprite)
	if animated_sprite:
		update_animation(dir)
		
		# Handle sprite flipping
		if dir != 0:
			animated_sprite.flip_h = dir < 0

	# Reset just_landed flag
	just_landed = false

	# Check for falling into void
	if position.y > 1000:  # Fell into the void → restart level
		get_tree().reload_current_scene()

func start_footstep_timer():
	if footstep_timer:
		# Adjust timer based on movement speed
		footstep_timer.wait_time = 0.25 if is_running else 0.4
		footstep_timer.start()

func _on_footstep_timer_timeout():
	if is_moving and footstep_audio:
		# Play footstep sound with slight pitch variation
		footstep_audio.pitch_scale = randf_range(0.8, 1.2)
		footstep_audio.play()

func update_animation(direction: float) -> void:
	if not animated_sprite:
		return
		
	if not is_on_floor():
		# In air - jumping or falling
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	elif direction != 0:
		# Moving horizontally
		if is_running:
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
	else:
		# Standing still
		animated_sprite.play("idle")

func add_screen_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration

func update_screen_shake(delta: float) -> void:
	if not camera:
		return
		
	if shake_duration > 0:
		shake_duration -= delta
		
		# Create random shake offset
		var shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		
		camera.offset = original_camera_offset + shake_offset
	else:
		# Return camera to original position
		camera.offset = original_camera_offset
		shake_intensity = 0.0

func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		# Screen shake on hit
		add_screen_shake(8.0, 0.3)
		# Play hit sound before restarting
		hit_audio.play()
		# Wait a moment for the sound to play, then restart
		await hit_audio.finished
		get_tree().reload_current_scene() 
