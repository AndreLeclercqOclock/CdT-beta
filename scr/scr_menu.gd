extends Control

func _on_Start_pressed():
	get_tree().change_scene("res://scn/base.tscn.xml")


func _on_Option_pressed():
	get_tree().change_scene("res://scn/option.tscn")
	GLOBAL.backoption = "res://scn/menu.tscn"


func _on_Credits_pressed():
	get_tree().change_scene("res://scn/credits.tscn")
	GLOBAL.backcredit = "res://scn/menu.tscn"
