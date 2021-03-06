extends KinematicBody2D

export var speed = 180
export(PackedScene) var weapon

const scent_scene = preload("res://scenes/Scent.tscn")
var velocity = Vector2()
var w = null
var scent_trail = []

onready var scent_timer = $ScentTimer

func _ready():
	scent_timer.connect("timeout", self, "add_scent")
	if weapon:
		w = weapon.instance()
#		Maybe global_position?
		w.position = $Position2D.position
		add_child(w)
		
func add_scent():
	var scent = scent_scene.instance()
	scent.init(self, scent_timer.wait_time)
	get_parent().add_child(scent)
	scent_trail.push_front(scent)

func get_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("move_back"):
		velocity = Vector2(-speed / 3, 0).rotated(rotation)
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	if w:
		w.attack()

func _physics_process(delta):
	get_input()
	var dir = get_global_mouse_position() - global_position
	
	if dir.length() > 5:
		rotation = dir.angle()
		velocity = move_and_slide(velocity)
