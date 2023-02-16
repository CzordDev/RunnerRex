extends KinematicBody2D

#Salto
export var fall_gravity_scale := 350.0 #Escala de la gravedad de caída
export var low_jump_gravity_scale := 300.0 #Escala de la gravedad del salto corto
export var on_duck_gravity_scale := 1000.0 #Escala de la gravedad mientras se está agachado
export var jump_power := 1100.0 #Potencia del salto
var jump_released = false
var duck_pressed = false

#Físicas
var velocity = Vector2() #Vector velocidad
var earth_gravity = 9.807 #Gravedad de la tierra expresada en m/s^2
export var gravity_scale := 300.0 #Escala de la gravedad
var on_floor := false
var was_on_floor := false

#Nodos
onready var collider = $NormalCollider
onready var duck_collider = $DuckCollider
onready var animator = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var jump_sound = $JumpSound
onready var shadow = $Shadow
onready var dust = $DustParticles

#Otros
var playing = false
signal fell_to_the_floor #Señal emitida al caer al suelo
signal game_over #Señal emitida al caer al suelo

func _ready():
	set_shadow_pos()
	pass

func _physics_process(delta):
	if Input.is_action_just_released("jump"):
		jump_released = true
	
	duck_pressed = Input.is_action_pressed("duck")

	#Aplicando la gravedad al jugador
	velocity += Vector2.DOWN * earth_gravity * gravity_scale * delta

	#Fisicas del salto
	if !on_floor && duck_pressed: #El personaje se está agachando
		velocity += Vector2.DOWN * earth_gravity * on_duck_gravity_scale * delta
	if velocity.y > 0: #El personaje está cayendo
		velocity += Vector2.DOWN * earth_gravity * fall_gravity_scale * delta 
		if playing:
			change_anim("Fall")
	elif velocity.y < 0 && jump_released: #El personaje está saltando
		velocity += Vector2.DOWN * earth_gravity * low_jump_gravity_scale * delta

	if on_floor:
		change_anim("Walk")
		if duck_pressed && playing:
			change_anim("Duck")
		elif Input.is_action_just_pressed("jump"):
			change_anim("Jump")
			jump_sound.play()
			velocity = Vector2.UP * jump_power #Salto normal
			jump_released = false
		elif !playing:
			change_anim("Idle")
	
	dust.emitting = on_floor && playing
#	dust.visible = on_floor && playing

	#Cambiar la colisión activa dependiendo de si el jugador se agacha
	duck_collider.set_deferred("disabled", duck_pressed && on_floor)
	collider.set_deferred("disabled", !(duck_pressed && on_floor))
		
	was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP) 

	on_floor = is_on_floor()
	
	if !was_on_floor && is_on_floor():
		emit_signal("fell_to_the_floor")

#Fijar la posición de la sombra
func set_shadow_pos():
	var shadow_global_pos = shadow.global_position
	shadow.set_as_toplevel(true)
	shadow.global_position = shadow_global_pos

#Cambiar la animación en el animation tree
func change_anim(anim : String):
	state_machine.travel(anim)
	pass

#Muerte del jugador
func die():
	playing = false
	dust.emitting = false
	velocity = Vector2.ZERO
	set_physics_process(false)
	change_anim("Die")
	emit_signal("game_over")
	pass
