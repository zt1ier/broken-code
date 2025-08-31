class_name Player extends CharacterBody2D


const DEFAULT_COLOR: Color = Color.RED


@export var speed: float = 400.0
@export var dash_cooldown: float = 1.0

@export var triangle_draw_points : Array[Vector2] = [
	Vector2(0, -16),
	Vector2(-24, 24),
	Vector2(24, 24)
]


var can_dash: bool = false


@onready var dash_timer: Timer = $DashTimer


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")
	dash_timer.wait_time = dash_cooldown


func _physics_process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)

	_handle_movement(delta)
	move_and_slide()


func _handle_movement(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir.normalized() * speed

	if Input.is_action_just_pressed("dash"):
		dash(delta)


func dash(delta: float) -> void:
	pass
