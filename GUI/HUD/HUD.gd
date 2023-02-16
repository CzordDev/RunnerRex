extends CanvasLayer

#Nodos
onready var score_label = $TopContainer/ScoresContainer/ScoreLabel
onready var h_score_label = $TopContainer/ScoresContainer/HighScoreLabel
onready var label = $CenterContainer/Label
onready var animator = $AnimationPlayer
onready var state_machine = $AnimationTree.get("parameters/playback")

#Dar formato a la puntuación (Ejemplo: si se le pasa 100 como parametro, retorna el string "00100")
func format_score(score: int, max_digits := 5) -> String:
	var score_digits := len(str(score)) #Digitos del numero
	var formated_score := "" #Variable que almacenará el resultado final
	
	for i in range(max_digits - score_digits): #Completa los digitos faltantes con ceros
		formated_score += "0"
	
	formated_score += str(score)
	return formated_score

#Fijar el texto de los puntos
func set_score(new_score : int):
	score_label.text = format_score(new_score)
	pass

#Fijar el texto de la mayor puntuación
func set_high_score(new_score : int):
	h_score_label.text = "HI " + format_score(new_score)
	pass

#Cambiar la animación
func change_anim(anim : String):
	state_machine.travel(anim)
	pass

#Animación para mostrar el título del juego
func show_title():
	change_anim("Mostrar titulo")
	pass

func show_game_over():
	label.text = "Pesiona espacio para reiniciar"
	change_anim("game over")
	pass

#Animación para ocultar el título del juego
func hide_title():
	change_anim("Ocultar titulo")
	pass

#Animar el texto de la puntuación
func anim_score_label():
	animator.play("score_label_anim")

