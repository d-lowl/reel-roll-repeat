extends RigidBody2D

@export var rarity: String
@export var dice: Array

func _ready():
	$AnimatedSprite2D.animation = rarity
