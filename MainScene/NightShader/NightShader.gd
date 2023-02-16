extends Sprite

var is_night = false
onready var tween : Tween =  $Tween


func anochecer():
	if tween.is_active():
		tween.stop_all()
	var shader_value : float = material.get_shader_param("mix_amount")
	tween.interpolate_property(material, "shader_param/mix_amount", shader_value, 1.0, 2.0)
	tween.start()
	yield(tween, "tween_all_completed")
	is_night = true
	pass

func amanecer():
	if tween.is_active():
		tween.stop_all()
	var shader_value : float = material.get_shader_param("mix_amount")
	tween.interpolate_property(material, "shader_param/mix_amount", shader_value, 0.0, 2.0)
	tween.start()
	yield(tween, "tween_all_completed")
	is_night = false
	pass

func invertir():
	if is_night:
		amanecer()
	else:
		anochecer()
