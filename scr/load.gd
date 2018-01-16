extends Control


var launch = 1

var dict = {}
var save = {}
var saveg = {}
var lang = {}
var conf = {}

var saveDial = []
var saveRep = []
var saveTime = []
var saveNextTime = []
var menuText = []
var gameText = []
var optionsText = []
var creditsText = []
var chapter = []
var actualBGSound = null
var globalVariables = []

var scenarioFile = null
var firstDial = null
var lastDial = null
var stateSave = null
var version = null
var chapterSave = 2
var namePNJ = null
var firstBGSound = null

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

var data = null
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
var loadChapter = 0
var actualChapter = 1

var MusicButton = 1
var SoundButton = 1

var tween = null
var targetNode = null
var tweenType = null
var tweenStart = null
var tweenEnd = null
var tweenTime = null

func _ready():
	# Low CPU usage
	#OS.set_low_processor_usage_mode(true)
    # Récupération de la config
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/config.json"), File.READ)
	conf.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")

	# Récupération des variables dans le fichiers de configuration
	stateSave = conf._Config.stateSave
	version = conf._Config.version
		

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
		saveg.parse_json(file.get_line())
		file.close()
		print("Fermeture du JSON")

		print("Récupération du chapitre en cours")
		chapterSave = saveg._SaveGlobal.chapter
		if saveg._SaveGlobal.has("music"):
			MusicButton = saveg._SaveGlobal.music
		else:
			MusicButton = 1
			saveGlobal()
		if saveg._SaveGlobal.has("sound"):
			SoundButton = saveg._SaveGlobal.sound
		else:
			SoundButton = 1
			saveGlobal()
		if saveg._SaveGlobal.has("actualChapter"):
			actualChapter = saveg._SaveGlobal.actualChapter
		else:
			actualChapter = 1
			saveGlobal()
		if saveg._SaveGlobal.has("languageCode"):
			languageCode = saveg._SaveGlobal.languageCode
		else:
			languageCode = 0
			saveGlobal()

	selectLanguage()
	loadLanguage()

	if fileExists == false:
		MusicButton = 1
		SoundButton = 1
		chapterSave = 2
		actualChapter = 1
		languageCode = 0
		saveGlobal()
		

func _load_chapter():
	# Vérification de l'existence du fichier de sauvegarde
	print("Check du SaveLog")
	file2check = File.new()
	fileExists = file2check.file_exists(str("user://saveChapter",actualChapter,".json"))

	if fileExists == true and stateSave == true:
		# Récupération de la sauvegarde globale
		print("Chargement de la sauvegarde")
		print("Ouverture du JSON")
		var file = File.new()
		#file.open_encrypted_with_pass("user://savelogs.json", File.READ, "reg65er9g84zertg1zs9ert8g4")
		file.open(str("user://saveChapter",actualChapter,".json"), File.READ)
		save.parse_json(file.get_line())
		file.close()
		print("Fermeture du JSON")
		
		print("Récupération du dialogue en cours")
		for i in save._Save.dial:
			saveDial.append(i)
		print(saveDial)
		print("Récupération des réponses")
		for i in save._Save.rep:
			saveRep.append(i)
		print(saveRep)
		print("Récupération des Timers")
		for i in save._Save.nexttime:
			saveNextTime.append(i)
		print(saveNextTime)
		print("Récupération du son d'ambiance")
		actualBGSound = save._Save.actualBGSound
		loadsave = save._Save

	print(str("NOM DU SCENARIO",scenarioFile))
	# RECUPERATION DU SCENARIO
	# Ouverture / Parse / Fermeture du fichier JSON
	print("Initialisation du scénario")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/",scenarioFile,".json"), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")
	
	for item in dict.GlobalVariables[0].Variables:
		if item.Variable == "firstDial":
			firstDial = item.Value
		if item.Variable == "lastDial":
			lastDial = item.Value
		if item.Variable == "namePNJ":
			namePNJ = item.Value 
		if item.Variable == "firstBGSound":
			firstBGSound = item.Value 

	# Variables du scénario
	dial = dict.Packages[0].Models

	# Lancement du script
	print("Lancement du script")
	if fileExists == false:
		launch = 0
		print("Auto-Sauvegarde")
		time_delay = 1
		dataDial = firstDial
		dataRep = null
		dataNextTime = OS.get_unix_time() + int(time_delay)
		currentNextTime = OS.get_unix_time()
		currentDial = firstDial
		actualBGSound = firstBGSound

	get_tree().change_scene("res://scn/base.tscn")
	
func saveGlobal():
	data = {"_SaveGlobal" : {"chapter" : chapterSave,"actualChapter": actualChapter, "sound" : SoundButton, "music" : MusicButton,"languageCode" : languageCode}}
	var file = File.new()
	#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
	file.open("user://saveglobal.json", File.WRITE)
	file.store_line(data.to_json())
	file.close()
	return
	
func system_tween():
	if tween != null:
		tween.interpolate_property(targetNode, tweenType, tweenStart, tweenEnd, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	return

func selectLanguage():
	if languageCode == 0:
		languageSelect = conf._Config.FR_fr
	elif languageCode == 1:
		languageSelect = conf._Config.EN_us
	saveGlobal()
	return

func loadLanguage():
	# Récupération de la langue
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	print(str("LANGUAGE SELECT : ",languageSelect))
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

	for i in lang._Language.Credits:
		creditsText.append(i)
	
	for i in lang._Language.Config.scenarioFile:
		chapter.append(i)
		chapterNumber = chapterNumber+1
	return
