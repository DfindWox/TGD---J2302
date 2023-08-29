extends ParallaxBackground


@export var scrollig_speed = 40
func _process(delta):
	scroll_offset.x += scrollig_speed * delta
