extends ColorRect


@export var player: Player


var grid_offset: Vector2 = Vector2.ZERO


@onready var grid_material: ShaderMaterial = $CoolGreenGridThing.material


func _ready() -> void:
	if player == null:
		printerr("background.gd: Player reference is null")
		set_physics_process(false)


func _process(delta: float) -> void:
	_handle_camera_follow()


func _physics_process(delta: float) -> void:
	_handle_grid(delta)


func _handle_grid(delta: float) -> void:
	grid_offset -= player.velocity * delta
	grid_material.set_shader_parameter("offset", -grid_offset)


func _handle_camera_follow() -> void:
	global_position = player.global_position - (size / 2)
