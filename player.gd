extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (px/sec)
var screen_size # Size of the game window

# _ready is called whenever a node senters the scene tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# _process is called every frame
# delta is the frame length (amount of time it took previous frame to complete)
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Clamp player position so player stays on screen
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Choose correct animation based on direction
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(_body):
	hide()
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback
	# Disables player collision detection once the player is hit
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
