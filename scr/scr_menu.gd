extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	pass

func _on_Start_pressed():
	get_tree().change_scene("res://scn/base.tscn.xml")


func _on_Option_pressed():
	get_tree().change_scene("res://scn/option.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
