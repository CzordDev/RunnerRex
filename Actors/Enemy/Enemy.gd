extends Area2D

#Físicas
var speed := 300 #Velocidad del enemigo

func _physics_process(delta):
	global_position.x -= speed * delta #movimiento del enemigo
	if global_position.x < -32: #Si el enemigo sale de la pantalla, es eliminado
		queue_free()
	pass

#Fijar la posicion del enemigo. Funcion destinada a ser reescrita por nodos heredados
func set_pos(new_pos : Vector2):
	global_position = new_pos

#Colisión con un cuerpo físico
func _on_Enemy_body_entered(body): 
	body.die()
