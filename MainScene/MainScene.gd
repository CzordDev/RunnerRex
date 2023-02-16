extends Node2D

#Puntuación
var score : int = 0
var high_score : int = 0
#Velocidad
export var speed : float = 800
export var speed_scale : float = 1.0
export var speed_scale_increase_amount : float = 0.1
export var max_speed_scale : float = 2.0
#Spawneo de enemigos
export var min_spawn_time : float = 0.5
export var max_spawn_time : float = 2
#Dia y noche
var night_duration : int = 100

#Enemigos
var spawnable_enemies : Array = [] #Lista que contiene los enemigos
var cactus1 = preload("res://Actors/Enemy/Cactus/Cactus1.tscn")
var cactus2 = preload("res://Actors/Enemy/Cactus/Cactus2.tscn")
var cactus3 = preload("res://Actors/Enemy/Cactus/Cactus3.tscn")
var cactus4 = preload("res://Actors/Enemy/Cactus/Cactus4.tscn")
var cactus5 = preload("res://Actors/Enemy/Cactus/Cactus5.tscn")
var cactus6 = preload("res://Actors/Enemy/Cactus/Cactus6.tscn")
var cactus7 = preload("res://Actors/Enemy/Cactus/Cactus7.tscn")
var cactus8 = preload("res://Actors/Enemy/Cactus/Cactus8.tscn")
var ptero = preload("res://Actors/Enemy/Ptero/Ptero.tscn")

#Nodos
onready var parallax : ParallaxBackground = $Parallax
onready var enemy_spawn_point : Position2D = $EnemySpawPoint
onready var spawn_timer : Timer = $SpawnTimer
onready var score_timer : Timer = $ScoreTimer
onready var hud : CanvasLayer = $HUD
onready var player : KinematicBody2D = $Rex
onready var tween : Tween = $Tween
onready var game_over_sound : AudioStreamPlayer = $GameOverSound
onready var night_shader : Sprite = $NightShader

#Estado del juego
var playing : bool = false

func _ready():
	hud.set_score(score)
	parallax.set_process(false)
	player.playing = false
	load_high_score()
#	get_tree().paused = false
	pass

func _input(event):
	if event.is_action_pressed("ui_accept") && !playing:
#		aux = true
		score = 0
		hud.set_score(score)
		hud.hide_title()
		destroy_all_enemies()
		player.set_physics_process(true)
		yield(player, "fell_to_the_floor")
		start_game()
	pass

#Guardar puntuación maxima
func save_high_score():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	save_game.store_var(high_score)
	save_game.close()

#Cargar puntuación maxima
func load_high_score():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return #No hay datos guardados.
		
	save_game.open("user://savegame.save", File.READ)
	high_score = save_game.get_var()
	hud.set_high_score(high_score)
	save_game.close()

#Empezar nueva partida
func start_game():
	start_spawnable_enemies()
	playing = true
	player.playing = true
	parallax.scroll_speed = 0
	parallax.set_process(true)
	tween.interpolate_property(parallax, "scroll_speed", 0, speed, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	speed_scale = 1.0
	update_speed()
	spawn_timer.start()
	score_timer.start()
	pass

#Cargar enemigos espawnables al inicio
func start_spawnable_enemies():
	spawnable_enemies = [cactus1, cactus2, cactus3, cactus4, cactus5]
	pass

#Spawnear enemigo
func spawn_enemy():
	randomize()
	var enemy = spawnable_enemies[randi() % len(spawnable_enemies)]
	var e = enemy.instance()
	e.set_pos(enemy_spawn_point.global_position)
	e.speed = speed * speed_scale
	add_child(e)
	pass

#Destruir todos los enemigos en pantalla
func destroy_all_enemies():
	var enemies_array = get_tree().get_nodes_in_group("Enemy")
	
	if len(enemies_array) > 0:
		for e in enemies_array:
			e.queue_free()
	pass

#Actualizar la velocidad del fondo y de los enemigos
func update_speed():
	parallax.scroll_speed = speed * speed_scale
	for e in get_tree().get_nodes_in_group("Enemy"):
		e.speed = speed * speed_scale
	pass

func set_random_night_duration():
	var random_number = RandomNumberGenerator.new()
	random_number.randomize()
	#Fija la duración de la noche a un número aleatorio entre 200 y 400, y la duración del día entre 400 y 800
	night_duration = (random_number.randi_range(2, 4) + int(night_shader.is_night) * 2) * 100 
	pass

#Fin de una partida
func game_over():
#	get_tree().paused = true
	night_shader.amanecer()
	game_over_sound.play()
	parallax.set_process(false)
	for e in get_tree().get_nodes_in_group("Enemy"):
		e.set_physics_process(false)
	score_timer.stop()
	spawn_timer.stop()
	
	save_high_score()
	
	hud.show_game_over()
	yield(get_tree().create_timer(1.0), "timeout")
	playing = false
#	get_tree().reload_current_scene()
	pass

func _on_SpawnTimer_timeout():
	randomize()
	var max_wait_time : float = max_spawn_time + 1.0 - speed_scale
	max_wait_time = clamp(max_wait_time, 1, max_spawn_time)
	var new_wait_time : float = rand_range(min_spawn_time, max_wait_time)
	spawn_timer.wait_time = new_wait_time
	spawn_enemy()
	pass # Replace with function body.

func _on_ScoreTimer_timeout():
	#Sumar un punto y mostrarlo en pantalla
	score += 1
	hud.set_score(score)
	#Aumentar la velocidad cada 100 puntos
	if score % 100 == 0:
		speed_scale += speed_scale_increase_amount
		speed_scale = clamp(speed_scale, 1.0, max_speed_scale)
		hud.anim_score_label()
		update_speed()
	
	#Spawnear diferentes enemigos dependiendo la puntuación
	if score == 100:
		spawnable_enemies.append(cactus6)
	elif score == 200:
		spawnable_enemies.append(cactus7)
	elif score == 300:
		spawnable_enemies.append(cactus8)
	elif score == 400:
		spawnable_enemies.append(ptero)
	
	#Control del ciclo de día y noche
	if score == 1000:
		set_random_night_duration()
		night_shader.anochecer()
	if score > 1000 && score % night_duration ==  0:
		set_random_night_duration()
		night_shader.invertir()
	
	#Mostrar cuando se supere la puntuación máxima
	if score > high_score:
		high_score = score
		hud.set_high_score(high_score)

