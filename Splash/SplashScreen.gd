extends Node2D

onready var animator = $AnimationPlayer
#onready var timer = $Timer


func _ready():
	
	pass


func _on_Timer_timeout():
	animator.play("ShowSplash")
	yield(animator, "animation_finished")
	get_tree().call_deferred("change_scene", "res://MainScene/Main.tscn")
	#get_tree().change_scene("res://MainScene/Main.tscn")
	pass # Replace with function body.
