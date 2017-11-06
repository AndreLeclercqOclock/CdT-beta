extends Control

var dict = {}

var scenarioFile = null
var firstDial = null
var stateSave = null
var version = null

func _ready():
    # Récupération de la config
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/config.json"), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")

	# Récupération des variables dans le fichiers de configuration
	scenarioFile = dict._Config.scenarioFile
	firstDial = dict._Config.firstDial
	stateSave = dict._Config.stateSave
	version = dict._Config.version

	# Ouverture / Parse / Fermeture du fichier JSON
	print("Initialisation du scénario")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/",scenarioFile), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")

	