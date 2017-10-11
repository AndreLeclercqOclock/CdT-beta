# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.253

extends Control

# Déclaration de Variables
var dict = {}
var save = {}
var currentDial = null
var timer = null
var time_delay = 1
var image = null
var video = null
var content = null
var wait = false
var dial = []
var size = null
var online = 1
var configFile = "config.json"
var scenarioFile = null
var version = null
var stateSave = null
var date = null
var data = null
var dataDial = null
var dataRep = null
var dataTime = null
var firstDial = null
var temp = null
var currentRep = null
var currentTime = null
var vscroll = 50
var currentHour = null
var currentMinute = null
var currentSecond = null
var saveDial = []
var saveRep = []
var saveTime = []
var labelH = null
var hourIG = "0"
var minuteIG = "0"
var secondIG = "0"
var saveNextTime = 0
var unixTime = OS.get_unix_time()
var saveUnixTime = 0
var save_size = null

# Initialisation des bases du script
func _ready():
	print("Crédits")
	print("Script par LEIFER KOPF // leifer.kopf@gmail.com")
	print("Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com")
	print("Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé,	même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).")
	print("...................................................................................")
	print("#### LANCEMENT DU JEU ####")

# Récupération de la config
	print("Récupération de la configutation")
	print("Ouverture du JSON")
	var file = File.new()
	file.open(str("res://json/",configFile), File.READ)
	dict.parse_json(file.get_as_text())
	file.close()
	print("Fermeture du JSON")
# Récupération des variables dans le fichiers de configuration
	scenarioFile = dict._Config.scenarioFile
	currentDial = dict._Config.firstDial
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
	var file2check = File.new()
	var fileExists = file2check.file_exists("user://savelogs.json")
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
		for i in save._Save.time:
			saveTime.append(i)
		print(saveTime)
# Réécriture de la Sauvegarde
		print("Réécriture de la sauvegarde")
		vscroll = get_node("vbox/Mid/DialBox").get_size().height
		for i in range(save._Save.dial.size()):
			currentDial = save._Save.dial[i]
			currentRep = save._Save.rep[i]
			currentTime = save._Save.time[i]
		# Ecrit l'heure
			if currentTime != null:
				print("Horodatage")
				var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
				var label = labelbase.duplicate()
				label.set_name(str("LabelTime",currentTime))
				get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
				label.show()
				print("Affiche l'heure")
				label.set_text(str(currentTime))
				label.set("visibility/self_opacity",1)
				var labelH = label.get_text()
			if dict._Dialogues[currentDial].ref == 1:
		# Ecrit la ligne de dialogue
				for y in range(dict._Dialogues[currentDial].content.size()):
					print("Création du label")
					var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
					var label = labelbase.duplicate()
					print("Configuration du label")
					label.set_name(str("label",y))
					get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
					label.show()
					print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[y])
					label.set_text(str(dict._Dialogues[currentDial].content[y]))
				# Ajustement de la taille du label
					var labelsize = label.get_line_count()
					if labelsize == 1:
						label.set_size(Vector2(1030,55))
						label.set("rect/min_size",Vector2(1030,55))
					elif labelsize == 2:
						label.set_size(Vector2(1030,110))
						label.set("rect/min_size",Vector2(1030,110))
				# Auto Scroll
					yield(get_tree(), "idle_frame")
					get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
					vscroll = vscroll+label.get_size().height+20
					get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
					label.set("visibility/self_opacity",1)
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
					label.set_size(Vector2(1030,55))
					label.set("rect/min_size",Vector2(1030,55))
				elif labelsize == 2:
					label.set_size(Vector2(1030,110))
					label.set("rect/min_size",Vector2(1030,110))
				print(str("Taille du label :",label.get_size()))
			# Auto Scroll
				print("Scroll")
				yield(get_tree(), "idle_frame")
				get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
				vscroll = vscroll+label.get_size().height+20
				get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
				label.set("visibility/self_opacity",1)
		print("Fin du chargement")
		currentDial = dict._Dialogues[currentDial].next

		print("Réécriture Dialogues dans le JSON")


# Initialisation du Timer
	print("Initialitation du Timer")
	timer = get_node("Timer")
	timer.set_wait_time(time_delay)

# Affichage du nom de l'interlocuteur
	print("Affichage du nom")
	get_node("vbox/Top/Name").add_text(str(dict._Dialogues.name.name))

# Affichage de la version de dev en JEU
	print("Affichage version en jeu")
	get_node("vbox/Top/version").set_text(str(version))

# Lancement du script
	print("Lancement du script")
	start()

# Affichage de l'heure
	set_process(true)

func _process(delta):
	# Récupération de l'heure du système
	var timeSys = OS.get_time()
	var hourSys = timeSys.hour
	var minuteSys = timeSys.minute
	var secondSys = timeSys.second
	unixTime = OS.get_unix_time()

	# Ajustement de l'heure
	if hourSys < 10:
		hourIG = str("0",hourSys)
	else:
		hourIG = hourSys
	if minuteSys < 10:
		minuteIG = str("0",minuteSys)
	else:
		minuteIG = minuteSys
	if secondSys < 10:
		secondIG = str("0",secondSys)
	else:
		secondIG = secondSys

	# Affichage de l'heure
	get_node("vbox/Top/clock").set_text(str(hourIG,":",minuteIG,":",secondIG))

	if saveNextTime != 0 and unixTime >= int(saveNextTime):
		print("Fin du timer")
		saveNextTime = 0
		start()


############################### DEBUT DU SCRIPT ###############################
# Fonction ou reboucle le script quand il repart du début
func start():
	print("Début du processus d'interpretation du JSON")
	status()
	var currentHour = OS.get_time().hour
	var currentMinute = OS.get_time().minute
	var currentSecond = OS.get_time().second

									## DIALOGUES ##
# Gestion des dialogues de ref 1 [DIALOGUES]
	if dict._Dialogues[currentDial].ref == 1 :
		print("#### DIALOGUES REF : 1 ####")
# AUTO SAVE
		print("Auto-Sauvegarde")
		var currentHour = OS.get_time().hour
		var currentMinute = OS.get_time().minute
		var currentSecond = OS.get_time().second
		dataTime = str(currentHour,":",currentMinute,":",currentSecond)
		dataDial = currentDial
		dataRep = 9
		system_save()
# Horodatage
		print("Horodatage")
		print("Création du label")
		var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
		var label = labelbase.duplicate()
		print("Configuration du label")
		label.set_name("LabelTime")
		get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
		label.show()
		print("Affiche l'heure")
		label.set_text(str(currentHour,":",currentMinute,":",currentSecond))
		var labelH = label.get_text()
# Auto Scroll
		print("Scroll")
		yield(get_tree(), "idle_frame")
		get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
		vscroll = vscroll+label.get_size().height+20
		get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
		print("Affichage")
		var visible = 0
		time_delay = 0.05
		status()
		for i in range(9):
			label.set("visibility/self_opacity",visible)
			visible = visible + 0.10
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")

#Création de la node LABEL
		print("Traitement du Dialogue")
		for i in range(dict._Dialogues[currentDial].content.size()):
# Calcule le nombre de charactères
			print("Calcule du nombre de charactère dans la phrase")
			dial = [dict._Dialogues[currentDial].content[i]]
			size = (dial[0].length())/20
			print("Définition du temps d'écriture en secondes")
# Affiche le status "Ecrit un message"
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelStat")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name("LabelStatuts")
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			print("Message système 'Ecrit un message'")
			label.set_text("écrit un message...")
# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			vscroll = vscroll+label.get_size().height+20
			get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
			print("Affichage")
			var visible = 0
			time_delay = 0.05
			status()
			for i in range(9):
				label.set("visibility/self_opacity",visible)
				visible = visible + 0.10
				timer.set_wait_time(time_delay)
				timer.start()
				yield(get_node("Timer"), "timeout")

# Fourchettes en fonction de la taille du texte.
		# Inférieur à 0 seconde
			if size <= 0:
				size = 0.5
		# Entre 0 & 2 secondes
			elif size > 0 and size <= 2:
				size = 1.5
		# Entre 2 & 5 secondes
			elif size > 2 and size <= 5:
				size = 3.5
		# Entre 5 & 10 secondes
			elif size > 5 and size <= 10:
				size = 5
		# Supérieur à 10 secondes
			elif size > 10:
				size = 7
			print("Temps d'écriture : ",size," seconde(s)")

# Lance le timer en fonction du nombre de char dans le content
			print("Lancement du timer",time_delay," seconde(s)")
			time_delay = size
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")

# Temporisation courte entre le message système et le texte
			print("Temporisation : ",time_delay," seconde(s)")
			time_delay = 0.2
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			label.queue_free()
			print("Fin du timer")

# Ecrit la ligne de dialogue
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name(str("label",dict._Dialogues[currentDial],i))
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[i])
			label.set_text(str(dict._Dialogues[currentDial].content[i]))
# Ajustement de la taille du label
			var labelsize = label.get_line_count()
			print(str("Nombre de ligne :",labelsize))
			if labelsize == 1:
				label.set_size(Vector2(1030,55))
				label.set("rect/min_size",Vector2(1030,55))
			elif labelsize == 2:
				label.set_size(Vector2(1030,110))
				label.set("rect/min_size",Vector2(1030,110))
			print(str("Taille du label :",label.get_size()))


# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			vscroll = vscroll+label.get_size().height+20
			get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
			print("Affichage")
			var visible = 0
			for i in range(9):
				label.set("visibility/self_opacity",visible)
				visible = visible + 0.10
				time_delay = 0.05
				timer.set_wait_time(time_delay)
				timer.start()
				yield(get_node("Timer"), "timeout")

# Temporisation
			time_delay = 0.75
			print("Temporisation : ",time_delay," seconde(s)")
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")
			print("Fin de la ligne")

# Clos la boucle et passe au next
		print("Fin du dialogue")
		currentDial = dict._Dialogues[currentDial].next
		time_delay = dict._Dialogues[currentDial].time
		unixTime = OS.get_unix_time()
		saveNextTime = unixTime + int(time_delay)
		print("Lancement du timer",time_delay," seconde(s)")
		status()


									## REPONSES ##
# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if dict._Dialogues[currentDial].ref == 2 :
		print("#### DIALOGUES REF : 2 ####")
		print("Création de ",dict._Dialogues[currentDial].content.size()," bouton(s)")
		for i in range(dict._Dialogues[currentDial].content.size()):
			print("Création du bouton n°",dict._Dialogues[currentDial].button[i])
			get_node(str("vbox/Bot/Bouton",i)).set_text(str(dict._Dialogues[currentDial].button[i]))
			get_node(str("vbox/Bot/Bouton",i)).set_ignore_mouse(false)
			get_node(str("vbox/Bot/Bouton",i)).set_flat(false)
		timer.stop()
		print("Fin de la création des boutons")

# Gestion des dialogues de ref 3 [REPONSES VIA TEXTE PRECIS]
	if dict._Dialogues[currentDial].ref == 3:
		print("#### DIALOGUES REF : 3 ####")
		print("Affichage boite de dialogue")
		get_node("vbox/Bot/TextEdit").show()
		print("Nettoyage de la boite de dialogue")
		get_node("vbox/Bot/TextEdit").clear()
		timer.stop()



											## MESSAGES SYSTEM ##
# Les messages systèmes
	if dict._Dialogues[currentDial].ref == 4 :
		print("#### DIALOGUES REF : 4 ####")
# Ecrit la ligne de Dialogue
		print("Création du label")
		var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
		var label = labelbase.duplicate()
		print("Configuration du label")
		label.set_name(str("labelsys",0))
		get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
		label.show()
		print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[0])
		label.set_text(str(dict._Dialogues[currentDial].content[0]))

# Ajustement de la taille du label
		var labelsize = label.get_line_count()
		print(str("Nombre de ligne :",labelsize))
		if labelsize == 1:
			label.set_size(Vector2(1030,55))
			label.set("rect/min_size",Vector2(1030,55))
		elif labelsize == 2:
			label.set_size(Vector2(1030,110))
			label.set("rect/min_size",Vector2(1030,110))
		print(str("Taille du label :",label.get_size()))

# Auto Scroll
		print("Scroll")
		yield(get_tree(), "idle_frame")
		get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
		vscroll = vscroll+label.get_size().height+20
		get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
		print("Affichage")
		var visible = 0
		for i in range(9):
			label.set("visibility/self_opacity",visible)
			visible = visible + 0.10
			time_delay = 0.05
			timer.set_wait_time(time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")

			currentDial = dict._Dialogues[currentDial].next[0]
			time_delay = dict._Dialogues[currentDial].time

# Temporisation
		time_delay = 0.75
		print("Temporisation : ",time_delay," seconde(s)")
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")
		print("Fin du timer")
		print("Fin de la ligne")

# Clos la boucle et passe au next
		timer.set_wait_time(time_delay)
		print("Lancement du timer",time_delay," seconde(s)")
		timer.start()
		yield(get_node("Timer"), "timeout")
		print("Fin du timer")
		start()

										## BOUTONS REPONSES ##
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	clean()
	print("Bouton n°0 activé")
# AUTO SAVE
	dataDial = currentDial
	dataRep = 0
	dataTime = null
	system_save()

# Ecrit la ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",dict._Dialogues[currentDial],0))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[0])
	label.set_text(str(dict._Dialogues[currentDial].content[0]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(1030,55))
		label.set("rect/min_size",Vector2(1030,55))
	elif labelsize == 2:
		label.set_size(Vector2(1030,110))
		label.set("rect/min_size",Vector2(1030,110))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = dict._Dialogues[currentDial].next[0]
	time_delay = dict._Dialogues[currentDial].time
	saveNextTime = OS.get_unix_time() + int(time_delay)
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 1
func _on_Bouton1_pressed():
	clean()
	print("Bouton n°1 activé")
# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 1
	dataTime = null
	system_save()

# Ecrit la ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",dict._Dialogues[currentDial],1))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[1])
	label.set_text(str(dict._Dialogues[currentDial].content[1]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(1030,55))
		label.set("rect/min_size",Vector2(1030,55))
	elif labelsize == 2:
		label.set_size(Vector2(1030,110))
		label.set("rect/min_size",Vector2(1030,110))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = dict._Dialogues[currentDial].next[1]
	time_delay = dict._Dialogues[currentDial].time
	saveNextTime = OS.get_unix_time() + int(time_delay)
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 2
func _on_Bouton2_pressed():
	clean()
	print("Bouton n°2 activé")

# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 2
	dataTime = null
	system_save()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",dict._Dialogues[currentDial],2))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[2])
	label.set_text(str(dict._Dialogues[currentDial].content[2]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(1030,55))
		label.set("rect/min_size",Vector2(1030,55))
	elif labelsize == 2:
		label.set_size(Vector2(1030,110))
		label.set("rect/min_size",Vector2(1030,110))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")


	currentDial = dict._Dialogues[currentDial].next[2]
	time_delay = dict._Dialogues[currentDial].time
	saveNextTime = OS.get_unix_time() + int(time_delay)
	print("Lancement du timer",time_delay," seconde(s)")

# BOUTON 3
func _on_Bouton3_pressed():
	clean()
	print("Bouton n°3 activé")

# AUTO SAVE
	print("Auto-Sauvegarde")
	dataDial = currentDial
	dataRep = 3
	dataTime = null
	system_save()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",dict._Dialogues[currentDial],3))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",dict._Dialogues[currentDial].content[3])
	label.set_text(str(dict._Dialogues[currentDial].content[3]))

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(1030,55))
		label.set("rect/min_size",Vector2(1030,55))
	elif labelsize == 2:
		label.set_size(Vector2(1030,110))
		label.set("rect/min_size",Vector2(1030,110))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	vscroll = vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(vscroll)
# Affichage Smoothie
	print("Affichage")
	var visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")

	currentDial = dict._Dialogues[currentDial].next[3]
	time_delay = dict._Dialogues[currentDial].time
	saveNextTime = OS.get_unix_time() + int(time_delay)
	print("Lancement du timer",time_delay," seconde(s)")

# Nettoyage des boutons inutiles
func clean():
	print("Suppression des boutons")
	for i in range(4):
		get_node(str("vbox/Bot/Bouton",i)).set_text("")
		get_node(str("vbox/Bot/Bouton",i)).set_ignore_mouse(true)
		get_node(str("vbox/Bot/Bouton",i)).set_flat(true)

									## BOITE DE DIALOGUE REPONSES ECRITE ##
# Boite de dialogue pour écrire la réponse demandée.
func _on_TextEdit_text_entered( text ):
	if get_node("vbox/Bot/TextEdit").get_text() == dict._Dialogues[currentDial].content[0]:
		get_node("vbox/Mid/Dialogues").push_align(2)
		get_node("vbox/Mid/Dialogues").add_text(str("Moi : ",dict._Dialogues[currentDial].content[0]))
		get_node("vbox/Bot/TextEdit").hide()
		get_node("vbox/Bot/TextEdit").clear()
		currentDial = dict._Dialogues[currentDial].next[0]
		time_delay = dict._Dialogues[currentDial].time
		timer.set_wait_time(time_delay)
		print("Lancement du timer",time_delay," seconde(s)")
		timer.start()
		yield(get_node("Timer"), "timeout")
		print("Fin du timer")
		start()
	else:
		currentDial = dict._Dialogues[currentDial].next[1]
		time_delay = dict._Dialogues[currentDial].time
		timer.set_wait_time(time_delay)
		print("Lancement du timer",time_delay," seconde(s)")
		timer.start()
		yield(get_node("Timer"), "timeout")
		print("Fin du timer")
		start()

		## FONCTIONS DIVERSES ##
# Toutes les fonctions utiles
func status():
# Status de l'interlocuteur
	print("Status de l'interlocuteur")
	var statusOld = get_node("vbox/Top/Etat").get_text()
	# En ligne
	if time_delay <= 30:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("En ligne")
	# Occupé
	elif time_delay > 30 and time_delay <= 180:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Occupé")
	# Absent
	elif time_delay > 180 and time_delay <= 300:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Absent")
	# Hors Ligne
	elif time_delay > 300:
		get_node("vbox/Top/Etat").clear()
		get_node("vbox/Top/Etat").add_text("Hors Ligne")
	var statusNew = get_node("vbox/Top/Etat").get_text()
	return

# Reset de la sauvegarde
func _on_resetSave_pressed():
	Directory.new().remove("user://savelogs.json")
	get_tree().reload_current_scene()

# SYSTEME DE SAUVEGARDE
func system_save():
	print("Auto-Sauvegarde")
	saveDial.push_back(dataDial)
	saveRep.push_back(dataRep)
	saveTime.push_back(dataTime)
	print(saveDial)
	print(saveRep)
	print(saveTime)
	saveUnixTime = OS.get_unix_time() + int(time_delay)
	data = {"_Save" : {"dial" : saveDial,"rep" : saveRep, "time" : saveTime, "nexttime" : saveUnixTime}}
	var file = File.new()
	#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
	file.open("user://savelogs.json", File.WRITE)
	file.store_line(data.to_json())
	file.close()
	return
