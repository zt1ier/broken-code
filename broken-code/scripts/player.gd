class_name Player extends CharacterBody2D


@export var speed: float = 400.0
@export var dash_cooldown: float = 1.5
@export var dash_speed: float = 5000.0
@export var dash_duration: float = 0.1


var can_dash: bool = true
var is_dashing: bool = false
var dash_dir: Vector2 = Vector2.ZERO


@onready var dash_cooldown_timer: Timer = $DashCooldown
@onready var dash_duration_timer: Timer = $DashTimer


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")

	dash_cooldown_timer.wait_time = dash_cooldown
	dash_duration_timer.wait_time = dash_duration


func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

	if is_dashing:
		velocity = dash_dir * dash_speed
	else:
		var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = dir.normalized() * speed

		if Input.is_action_just_pressed("dash") and can_dash:
			start_dash(dir, mouse_pos)

	move_and_slide()


func start_dash(direction: Vector2, mouse_pos: Vector2) -> void:
	can_dash = false
	is_dashing = true

	# dash towards mouse
	dash_dir = (mouse_pos - global_position).normalized()

	dash_duration_timer.start()
	dash_cooldown_timer.start()


func _on_dash_duration_timeout() -> void:
	is_dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
