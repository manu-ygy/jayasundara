extends CanvasLayer

@onready var mp_bar = $Wrapper/Status/Player/MPBar

@onready var under_bar = $Wrapper/Status/Player/HP/UnderBar
@onready var hp_bar = $Wrapper/Status/Player/HP/HPBar

func update_hp_bar(value):
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar, 'value', value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(under_bar, 'value', value, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func update_mp_bar(value):
	var tween = get_tree().create_tween()
	tween.tween_property(mp_bar, 'value', value, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
