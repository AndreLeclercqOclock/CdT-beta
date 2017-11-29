extends Control


var launch = 1

var dict = {}
var save = {}
var lang = {}

var saveDial = []
var saveRep = []
var saveTime = []
var saveNextTime = []
var menuText = []
var gameText = []
var optionsText = []
var chapter = []

var scenarioFile = null
var firstDial = null
var stateSave = null
var version = null
var chapterSave = null

var vscroll = 50

var ref = null
var content = null
var next = null
var time = null
var dial = null
var loadsave = null

var currentDial = null
var currentRep = null
var currentNextTime = null
var currentTime = null

var dataDial = null
var dataRep = null
var dataNextTime = null

var timeIG = null
var time_delay = 0
var file2check = File.new()
var fileExists = file2check.file_exists("user://saveglobal.json")

var scene = null
var node = null

var languageCode = 0
var languageSelect = null

var chapterNumber = 0


func _ready():
	# Low CPU usage
	#OS.set_low_processor_usage_mode(true)

    # Récupération de la config
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/config.json"), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")

	# Récupération des variables dans le fichiers de configuration
	firstDial = dict._Config.firstDial
	stateSave = dict._Config.stateSave
	version = dict._Config.version

	if languageCode == 0:
		languageSelect = dict._Config.FR_fr
	elif languageCode == 1:
		languageSelect = dict._Config.EN_en

	
	# Récupération de la langue
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/",languageSelect), File.READ)
	lang.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")

	for i in lang._Language.Menu:
		menuText.append(i)

	for i in lang._Language.Game:
		gameText.append(i)

	for i in lang._Language.Options:
		optionsText.append(i)
	
	for i in lang._Language.Config.scenarioFile:
		chapter.append(i)
		chapterNumber = chapterNumber+1
	
		

	# Vérification de l'existence du fichier de sauvegarde
	print("Check du SaveLog")
	file2check = File.new()
	fileExists = file2check.file_exists("user://saveglobal.json")
	

	# Chargement de la sauvegarde
	print("Chargement de la sauvegarde")
	
	if fileExists == true and stateSave == true:
	# Récupération de la sauvegarde globale
		print("Chargement de la sauvegarde")
		print("Ouverture du JSON")
		var file = File.new()
		#file.open_encrypted_with_pass("user://savelogs.json", File.READ, "reg65er9g84zertg1zs9ert8g4")
		file.open("user://saveglobal.json", File.READ)
		dict.parse_json(file.get_line())
		file.close()
		print("Fermeture du JSON")

		print("Récupération du chapitre en cours")
		chapterSave = dict._SaveGlobal.chapter


	if fileExists == false:
		data = {"_SaveGlobal" : {"chapter" : 1}}
		var file = File.new()
		#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
		file.open("user://saveglobal.json", File.WRITE)
		file.store_line(data.to_json())
		file.close()
		chapterSave = 1

	
	# Vérification de l'existence du fichier de sauvegarde
	print("Check du SaveLog")
	file2check = File.new()
	fileExists = file2check.file_exists("user://saveglobal.json")

	if fileExists == true and stateSave == true:
		# Récupération de la sauvegarde globale
		print("Chargement de la sauvegarde")
		print("Ouverture du JSON")
		var file = File.new()
		#file.open_encrypted_with_pass("user://savelogs.json", File.READ, "reg65er9g84zertg1zs9ert8g4")
		file.open("user://saveglobal.json", File.READ)
		dict.parse_json(file.get_line())
		file.close()
		print("Fermeture du JSON")
		
		print("Récupération du dialogue en cours")
		for i in dict._Save.dial:
			saveDial.append(i)
		print(saveDial)
		print("Récupération des réponses")
		for i in dict._Save.rep:
			saveRep.append(i)
		print(saveRep)
		print("Récupération des Timers")
		for i in dict._Save.nexttime:
			saveNextTime.append(i)
		print(saveNextTime)
		loadsave = dict._Save

	# Ouverture / Parse / Fermeture du fichier JSON
	print("Initialisation du scénario")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/",scenarioFile), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")
	
	# Lancement du script
	print("Lancement du script")
	if fileExists == false:
		launch = 0
		print("Auto-Sauvegarde")
		time_delay = dict._Dialogues[firstDial].time
		dataDial = firstDial
		dataRep = null
		dataNextTime = OS.get_unix_time() + int(time_delay)
		currentNextTime = OS.get_unix_time()
		currentDial = firstDial
		
	# Variables du scénario
	dial = dict._Dialogues

	print("FIN DU SCRIPT !!!")
	
	