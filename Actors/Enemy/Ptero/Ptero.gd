extends "res://Actors/Enemy/Enemy.gd" #Script heredado del enemigo

#Logica de la posición inicial
var max_height_spawn : float = 225.0 #Máxima altura de spawneo
var min_floor_distance : float = 50.0 #Distancia mínima con repecto al suelo

onready var animator = $AnimationPlayer

##Fijar la posicion del enemigo. Reescribe la función del nodo Enemy
func set_pos(new_pos : Vector2):
	$Shadow.set_deferred("global_position", new_pos) #Fija la posición de la sombra al suelo
	randomize() #Crea una nueva semilla aleatoria
	var new_y = rand_range(max_height_spawn, new_pos.y - min_floor_distance) #Elije una altura aleatoria entre la posición del suelo y la altura máxima
	global_position = Vector2(new_pos.x, new_y) #Fija la posición
	pass
