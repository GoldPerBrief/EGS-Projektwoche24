extends Area2D

@onready var coin_object = get_parent()
@onready var points_amount = coin_object.get_meta("value")
@onready var player = coin_object.get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(points_amount)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_overlapping_bodies():
		#print("true")
		#print(get_overlapping_bodies())
		#print(player)
		if get_overlapping_bodies().has(player):
			#print("doubly true")
			coin_object.queue_free()
			player.collect_stuff(points_amount)
	pass
