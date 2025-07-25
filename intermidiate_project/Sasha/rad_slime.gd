extends AnimatedSprite2D

@export var SPEED = 400.0
@export var SLIME : PackedScene

var direction = -1
var time: float = 0;
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var down_right_ray: RayCast2D = $DownRightRay
@onready var down_left_ray: RayCast2D = $DownLeftRay
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var health : int = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	animated_sprite_2d.play("idle")


func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
	time += delta
	
	if time >= 10.:
		var slime = GameManager.my_instantiate(SLIME)
		get_tree().root.add_child(slime)
		slime.global_position = global_position
		
		time = 0
	
	if (right_ray.is_colliding() or not(down_right_ray.is_colliding())):
		var col = right_ray.get_collider()
		if (not right_ray.is_colliding() or not col.is_in_group("player")):
			direction = -1
			animated_sprite_2d.flip_h = false
		
	if (left_ray.is_colliding() or not(down_left_ray.is_colliding())):
		var col = left_ray.get_collider()
		if (not left_ray.is_colliding() or not col.is_in_group("player")):
			direction = 1
			animated_sprite_2d.flip_h = true

func get_hit() -> void:
	print("hit")
	health -= 1
	if health == 0:
		animation_player.play("die")
		area_2d.collision_mask = 0
		SPEED = 0.0
		animation_player.animation_finished.connect(die)
		for i in range(42):
			var slime = GameManager.my_instantiate(SLIME)
			get_tree().root.add_child(slime)
			slime.global_position = global_position + Vector2(randf() * 420, randf() * 520)
			(slime as Node2D).scale = scale
	else:
		animation_player.play("hit")

func die(anim_name: StringName) -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Arrow:
		var arr = area.get_parent() as Arrow
		if !arr.stuck:
			get_hit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()
