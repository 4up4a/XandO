extends Area2D
signal hit

@onready var joy: Node2D = $"../joy"
@export var explosion : PackedScene
#переменные
var speed = 500
var screen_size

func _on_body_entered(_body):
	hide() # Player disappears after being hit.

	hit.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Получаем входные данные
	var direction = joy.posvectr # Начальное значение вектора

	# Нормализуем вектор направления
	direction = direction
	# Обновляем положение спрайта
	position += direction * speed * delta # Умножаем на delta для плавности
	position = position.clamp(Vector2.ZERO, screen_size)
