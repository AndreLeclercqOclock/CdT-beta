extends Control


var launch = 1

var dict = {}
var save = {}

var scenarioFile = null
var firstDial = null
var stateSave = null
var version = null

var vscroll = null

var ref = null
var content = null
var next = null
var time = null
var dial = null

var currentDial = null
var currentRep = null
var currentNextTime = null
var currentTime = null

var saveTime = null
var saveDial = null
var saveRep = null
var saveNextTime = null

var dataDial = null
var dataRep = null
var dataNextTime = null

var timeIG = null
var time_delay = null
var file2check = File.new()
var fileExists = file2check.file_exists("user://savelogs.json")


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
	
	#	Vérification de l'existence du fichier de sauvegarde
	print("Check du SaveLog")
	file2check = File.new()
	fileExists = file2check.file_exists("user://savelogs.json")
	#dict = LOAD.dict
	# Chargement de la sauvegarde
	print("Chargement de la sauvegarde")
	if fileExists == true and stateSave == true:
	# Récupération de la sauvegarde
		print("Chargement de la sauvegarde")
		print("Ouverture du JSON")
		var file = File.new()
		#file.open_encrypted_with_pass("user://savelogs.json", File.READ, "reg65er9g84zertg1zs9ert8g4")
		file.open("user://savelogs.json", File.READ)
		save.parse_json(file.get_line())
		file.close()
		print("Fermeture du JSON")

		print("Récupération des dialogues")
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
	# Réécriture de la Sauvegarde
		print("Réécriture de la sauvegarde")
		vscroll = get_node("vbox/Mid/DialBox").get_size().height
		for i in range(save._Save.dial.size()):
			currentDial = save._Save.dial[i]
			currentRep = save._Save.rep[i]
			currentNextTime = save._Save.nexttime[i]
			if dict._Dialogues[currentDial].ref == 1 and currentNextTime <= OS.get_unix_time():
				# Ecrit l'heure
				print("Horodatage")
				saveTime = currentNextTime
				system_time()
				var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
				var label = labelbase.duplicate()
				label.set_name(str("LabelTime",currentTime))
				get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
				label.show()
				print("Affiche l'heure")
				label.set_text(str(" - ",timeIG))
				label.set("visibility/opacity",1)
				var labelH = label.get_text()
				# Ecrit la ligne de dialogue
				for y in range(dict._Dialogues[currentDial].content.size()):
					print("Création du label")
					var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
					var label = labelbase.duplicate()
					print("Configuration du label")
					label.set_name(str("label",y))
					var labelbg = str("vbox/Mid/DialBox/VBoxMid/label",y,"/LabelBG")
					print(labelbg)
					get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
					label.show()
					print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[y])
					label.set_text(str(" ",dict._Dialogues[currentDial].content[y]))
				# Ajustement de la taille du label
					var labelsize = label.get_line_count()
					if labelsize == 1:
						label.set_size(Vector2(925,50))
						label.set("rect/min_size",Vector2(925,50))
						get_node(labelbg).set("transform/scale",Vector2(1,1))
					elif labelsize == 2:
						label.set_size(Vector2(925,110))
						label.set("rect/min_size",Vector2(925,110))
						get_node(labelbg).set("transform/scale",Vector2(1,2))
					elif labelsize == 3:
						label.set_size(Vector2(925,165))
						label.set("rect/min_size",Vector2(925,165))
						get_node(labelbg).set("transform/scale",Vector2(1,3))
				# Auto Scroll
					yield(get_tree(), "idle_frame")
					get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
					vscroll = vscroll+label.get_size().height+20
					get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
					label.set("visibility/opacity",1)
		# Ecrit la ligne de réponse
			elif dict._Dialogues[currentDial].ref == 2:
			# Ecrit la ligne de Dialogue
				print("Création du label")
				var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
				var label = labelbase.duplicate()
				print("Configuration du label")
				label.set_name(str("label",dict._Dialogues[currentDial],currentRep))
				get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
				label.show()
				print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[currentRep])
				label.set_text(str(dict._Dialogues[currentDial].content[currentRep]))
			# Ajustement de la taille du label
				var labelsize = label.get_line_count()
				print(str("Nombre de ligne :",labelsize))
				if labelsize == 1:
					label.set_size(Vector2(925,55))
					label.set("rect/min_size",Vector2(925,55))
				elif labelsize == 2:
					label.set_size(Vector2(925,110))
					label.set("rect/min_size",Vector2(925,110))
				elif labelsize == 3:
					label.set_size(Vector2(925,165))
					label.set("rect/min_size",Vector2(925,165))
				print(str("Taille du label :",label.get_size()))
			# Auto Scroll
				print("Scroll")
				yield(get_tree(), "idle_frame")
				get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
				vscroll = vscroll+label.get_size().height+20
				get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
				label.set("visibility/self_opacity",1)
		print("Fin du chargement")
		print("Réécriture Dialogues dans le JSON")

	# Lancement du script
	print("Lancement du script")
	if fileExists == false:
		launch = 0
		print("Auto-Sauvegarde")
		var unixTime = OS.get_unix_time()
		time_delay = dict._Dialogues[firstDial].time
		dataDial = firstDial
		dataRep = null
		dataNextTime = unixTime + int(time_delay)
		currentNextTime = OS.get_unix_time()
		currentDial = firstDial
		#system_save()
		#start()
	elif fileExists == true and currentNextTime <= OS.get_unix_time():
		currentDial = dict._Dialogues[currentDial].next
		launch = 1
	print("FIN DU SCRIPT !!!")

	# Variables du scénario
	ref = dict._Dialogues[currentDial].ref
	content = dict._Dialogues[currentDial].content
	next = dict._Dialogues[currentDial].next
	time = dict._Dialogues[currentDial].time
	dial = dict._Dialogues[currentDial]