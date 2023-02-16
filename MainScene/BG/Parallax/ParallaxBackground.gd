extends ParallaxBackground

#Velocidad a la que se mueve el fondo (cada capa de parallax se mueve a una velocidad relativa)
var scroll_speed : float = 500

func _process(delta):
	scroll_offset.x -= scroll_speed * delta #Movimiento del fondo
