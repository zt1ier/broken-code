class_name Player extends CharacterBody2D


const DEFAULT_COLOR: Color = Color.RED


@export var speed: float = 20000.0
@export var dash_cooldown: float = 1.5
@export var dash_distance: float = 1000.0

@export var triangle_draw_points : Array[Vector2] = [
	Vector2(0, -16),
	Vector2(-24, 24),
	Vector2(24, 24)
]


var can_dash: bool = false
var mouse_pos: Vector2 = Vector2.ZERO


@onready var dash_cooldown_timer: Timer = $DashCooldown


func _ready() -> void:
	if not is_in_group("Player"):
		add_to_group("Player")
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.start()


func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

	_handle_movement(delta)
	move_and_slide()


func _handle_movement(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed * delta

	if Input.is_action_just_pressed("dash") and can_dash:
		dash(direction, delta)


func dash(direction: Vector2, delta: float) -> void:
	can_dash = false

	if direction == Vector2.ZERO:
		global_position = to_local(mouse_pos).normalized() * dash_distance * delta
	else:
		global_position = direction.normalized() * dash_distance * delta

	dash_cooldown_timer.start()


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
