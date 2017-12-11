# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.253

extends Control

# Variables
var save = {}
var currentDial = null
var timer = null
var time_delay = 1
var content = null
var dial = []
var size = null
var scenarioFile = null
var version = null
var stateSave = null
var data = null
var dataDial = null
var dataRep = null
var firstDial = null
var currentRep = null
var currentTime = null
var vscroll = 50
var saveDial = []
var saveRep = []
var saveTime = []
var labelH = null
var hourIG = "0"
var minuteIG = "0"
var secondIG = "0"
var saveNextTime = []
var dataNextTime = null
var unixTime = OS.get_unix_time()
var timeIG = null
var calcultime = 0
var timezone = 0
var realtime = 0
var buttonPressed = null
var statusText = null
var status = 0
var statusNext = 0
var visible = 1
var led = null
var sound = 0
var triggerName = null
var triggerVol = 0
var lastRep = null
var bg_sound = null
var bg_sound_vol = null
var actualContent = []

############################### PREPARATION DU SCRIPT ###############################

# Ready
func _ready():
	print("Crédits")
	print("Script par LEIFER KOPF // leifer.kopf@gmail.com")
	print("Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com")
	print("Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé,	même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).")
	print("...................................................................................")
	print("#### LANCEMENT DU JEU ####")

	# Texte Popup Options
	get_node("Popup/VBox/Reset/Label").set_text(str(LOAD.optionsText[0]))
	get_node("Popup/VBox/Retour/Label").set_text(str(LOAD.optionsText[2]))
	get_node("Popup/VBox/Quitter/Label").set_text(str(LOAD.optionsText[3]))

	# Initialisation du Timer
	print("Initialitation du Timer")
	timer = get_node("Timer")
	timer.set_wait_time(0.01)
	
	# Calcule time zone
	timezone = OS.get_datetime_from_unix_time(OS.get_unix_time()).hour
	realtime = OS.get_time().hour
	calcultime = realtime - timezone

	if LOAD.fileExists == true and LOAD.stateSave == true:
		# Ecran de chargement
		get_node("Loading").popup()
		get_node("Loading/Label").set_text(LOAD.gameText[7])
		# Réécriture de la Sauvegarde
		print("Réécriture de la sauvegarde")
		LOAD.vscroll = get_node("vbox/Mid/DialBox").get_size().height
		for i in range(LOAD.loadsave.dial.size()):
			LOAD.currentDial = LOAD.loadsave.dial[i]
			LOAD.currentRep = LOAD.loadsave.rep[i]
			LOAD.currentNextTime = LOAD.loadsave.nexttime[i]
			# Vérification du status
			LOAD.time_delay = LOAD.dial[LOAD.currentDial].time
			status()
			if LOAD.dial[LOAD.currentDial].ref == 1 and LOAD.currentNextTime <= OS.get_unix_time():
				# Vérification du status
				LOAD.time_delay = 1
				status()
				# Ecrit l'heure
				print("Horodatage")
				LOAD.saveTime = LOAD.currentNextTime
				system_time()
				var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
				var label = labelbase.duplicate()
				label.set_name(str("LabelTime",LOAD.currentTime))
				get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
				label.show()
				print("Affiche l'heure")
				#label.set_text(str(" - ",LOAD.timeIG))
				label.set_text(str(" - ",LOAD.timeIG," : ",LOAD.currentDial," : ",LOAD.dial[LOAD.currentDial].next))
				label.set("visibility/opacity",1)
				var labelH = label.get_text()
				# Ecrit la ligne de dialogue
				for y in range(LOAD.dial[LOAD.currentDial].content.size()):
					print("Création du label")
					var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
					var label = labelbase.duplicate()
					print("Configuration du label")
					label.set_name(str("label",y))
					var labelbg = str("vbox/Mid/DialBox/VBoxMid/label",y,"/LabelBG")
					print(labelbg)
					get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
					label.show()
					print("Ecrit la ligne de dialogue : ",LOAD.dial[LOAD.currentDial].content[y])
					label.set_text(str(LOAD.dial[LOAD.currentDial].content[y]))
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
						label.set_size(Vector2(925,170))
						label.set("rect/min_size",Vector2(925,170))
						get_node(labelbg).set("transform/scale",Vector2(1,3))
					elif labelsize == 4:
						label.set_size(Vector2(925,230))
						label.set("rect/min_size",Vector2(925,230))
						get_node(labelbg).set("transform/scale",Vector2(1,4))
					elif labelsize == 5:
						label.set_size(Vector2(925,290))
						label.set("rect/min_size",Vector2(925,290))
						get_node(labelbg).set("transform/scale",Vector2(1,5))
				# Auto Scroll
					yield(get_tree(), "idle_frame")
					get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
					LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
					get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
					label.set("visibility/opacity",1)

		# Ecrit la ligne de réponse
			elif LOAD.dial[LOAD.currentDial].ref == 2:
			# Ecrit la ligne de Dialogue
				print("Création du label")
				var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
				var label = labelbase.duplicate()
				print("Configuration du label")
				label.set_name(str("label",LOAD.dial[LOAD.currentDial],LOAD.currentRep))
				get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
				label.show()
				print("Ecrit la ligne de dialogue : ",LOAD.dial[LOAD.currentDial].content[LOAD.currentRep])
				label.set_text(str(LOAD.dial[LOAD.currentDial].content[LOAD.currentRep]))
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
					label.set_size(Vector2(925,170))
					label.set("rect/min_size",Vector2(925,170))
				elif labelsize == 4:
					label.set_size(Vector2(925,230))
					label.set("rect/min_size",Vector2(925,230))
				elif labelsize == 5:
					label.set_size(Vector2(925,290))
					label.set("rect/min_size",Vector2(925,290))
				print(str("Taille du label :",label.get_size()))
			# Auto Scroll
				print("Scroll")
				yield(get_tree(), "idle_frame")
				get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
				LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
				get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
				label.set("visibility/self_opacity",1)
			elif LOAD.dial[LOAD.currentDial].ref == 3:
				# Ecriture du message système
				for i in range(LOAD.dial[LOAD.currentDial].content.size()):
					print("Création du label")
					var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
					var label = labelbase.duplicate()
					print("Configuration du label")
					label.set_name(str("label",LOAD.currentDial))
					get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
					label.show()
					label.set_text(str(LOAD.dial[LOAD.currentDial].content[i]))
					label.set("visibility/opacity",1)
					# Auto scroll
					print("Scroll")
					yield(get_tree(), "idle_frame")
					get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
					LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
					get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
					
			LOAD.time_delay = LOAD.dial[LOAD.currentDial].time
		print("Fin du chargement")
		print("Réécriture Dialogues dans le JSON")
		get_node("SampleBKG").play(str(LOAD.actualBGSound))
		get_node("SampleMSG").set_default_volume_db(0)
		get_node("Loading").hide()
	if LOAD.fileExists == true and LOAD.currentNextTime <= OS.get_unix_time():
		LOAD.currentDial = LOAD.dial[LOAD.currentDial].next
		LOAD.launch = 1
	

# Affichage du nom de l'interlocuteur
	print("Affichage du nom")
	get_node("vbox/Top/Name").add_text(str(LOAD.dict._Dialogues.name.name))

# Affichage de la version de dev en JEU
	print("Affichage version en jeu")
	get_node("vbox/Top/version").set_text(str(LOAD.version))

	if LOAD.fileExists == false:
		get_node("SampleMSG").set_default_volume_db(0)
		start()
		
# Affichage de l'heure
	set_process(true)

# Process
func _process(delta):
	
	LOAD.saveTime = OS.get_unix_time()
	system_time()
	# Affichage de l'heure
	get_node("vbox/Top/clock").set_text(LOAD.timeIG)

	if LOAD.launch != 0 and LOAD.currentNextTime <= OS.get_unix_time():
		print("Fin du timer")
		LOAD.launch = 0
		start()



############################### DEBUT DU SCRIPT ###############################
# Fonction ou reboucle le script quand il repart du début
# Start
func start():
	visible = 0
	print("Début du processus d'interpretation du JSON")


									## DIALOGUES ##
# Gestion des dialogues de ref 1 [DIALOGUES]
# Dialogues 
	if LOAD.dial[LOAD.currentDial].ref == 1 :
		last_dial()
		LOAD.time_delay = 1
		status()
		# Attribution du type de son
		sound = 1
		# Vérification d'un trigger son
		if LOAD.dial[LOAD.currentDial].sound[0] == 1:
			trigger_sound()
		if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
			bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
			bg_sound_vol = LOAD.dial[LOAD.currentDial].bgsound[2]
			background_sound()
		print("#### DIALOGUES REF : 1 ####")
# Horodatage
		print("Horodatage")
		print("Création du label")
		LOAD.saveTime = LOAD.currentNextTime
		system_time()
		var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
		var label = labelbase.duplicate()
		print("Configuration du label")
		label.set_name("LabelTime")
		get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
		label.show()
		print("Affiche l'heure")
		#label.set_text(str(" - ",LOAD.timeIG))
		label.set_text(str(" - ",LOAD.timeIG," : ",LOAD.currentDial,"=>",LOAD.dial[LOAD.currentDial].next))
		var labelH = label.get_text()
# Auto Scroll
		print("Scroll")
		yield(get_tree(), "idle_frame")
		get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
		LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
		get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
# Affichage Smoothie
		print("Affichage")
		visible = 0
		LOAD.time_delay = 0.05
		#status()
		for i in range(9):
			label.set("visibility/opacity",visible)
			visible = visible + 0.10
			timer.set_wait_time(LOAD.time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
#Création de la node LABEL
########### REFONTE #############
		print("Traitement du Dialogue")
		actualContent = LOAD.dial[LOAD.currentDial].content[0]
		print(str("CURRENTRIAL ACTUEL : ",actualContent))
		actualContent = actualContent.split("\r\n\r\n")
		print(str("CURRENTRIAL ACTUEL : ",actualContent))
		print(str("CURRENTDIAL SIZE : ",actualContent.size())) 
		for i in range(actualContent.size()):
			print(str("CURRENTRIAL ACTUEL : ",actualContent[i]))
		
		
		for i in range(LOAD.dial[LOAD.currentDial].content.size()):
# Calcule le nombre de charactères
			print("Calcule du nombre de charactère dans la phrase")
			dial = [LOAD.dial[LOAD.currentDial].content[i]]
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
			#label.set_text("écrit un message...")
# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			LOAD.vscroll = LOAD.vscroll+10+20
			get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
# Affichage Smoothie
			print("Affichage")
			visible = 0
			LOAD.time_delay = 0.05
			#status()
			for i in range(9):
				label.set("visibility/opacity",visible)
				visible = visible + 0.10
				timer.set_wait_time(LOAD.time_delay)
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
			print("Lancement du timer",LOAD.time_delay," seconde(s)")
			LOAD.time_delay = size
			timer.set_wait_time(LOAD.time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")

# Temporisation courte entre le message système et le texte
			print("Temporisation : ",LOAD.time_delay," seconde(s)")
			LOAD.time_delay = 0.2
			timer.set_wait_time(LOAD.time_delay)
			timer.start()
			yield(get_node("Timer"), "timeout")
			label.queue_free()
			print("Fin du timer")		
# Trigger son message reçu
			sample_msg()
			sound = 0
# Ecrit la ligne de dialogue
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name(str("label",i))
			var labelname = label.get_name()
			var labelbg = str("vbox/Mid/DialBox/VBoxMid/",labelname,"/LabelBG")
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			print("Ecrit la ligne de dialogue : ",LOAD.dial[LOAD.currentDial].content[i])
			label.set_text(str(LOAD.dial[LOAD.currentDial].content[i]))
# Ajustement de la taille du label
			var labelsize = label.get_line_count()
			print(str("Nombre de ligne :",labelsize))
			if labelsize == 1:
				label.set_size(Vector2(925,50))
				label.set("rect/min_size",Vector2(925,50))
				get_node(labelbg).set("transform/scale",Vector2(1,1))
			elif labelsize == 2:
				label.set_size(Vector2(925,110))
				label.set("rect/min_size",Vector2(925,110))
				get_node(labelbg).set("transform/scale",Vector2(1,2))
			elif labelsize == 3:
				label.set_size(Vector2(925,170))
				label.set("rect/min_size",Vector2(925,170))
				get_node(labelbg).set("transform/scale",Vector2(1,3))
			elif labelsize == 4:
				label.set_size(Vector2(925,230))
				label.set("rect/min_size",Vector2(925,230))
				get_node(labelbg).set("transform/scale",Vector2(1,4))
			elif labelsize == 5:
				label.set_size(Vector2(925,290))
				label.set("rect/min_size",Vector2(925,290))
				get_node(labelbg).set("transform/scale",Vector2(1,5))
			print(str("Taille du label :",label.get_size()))


# Auto Scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
			get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)

# Affichage Smoothie
			print("Affichage")
			visible = 0
			for i in range(9):
				label.set("visibility/opacity",visible)
				visible = visible + 0.10
				LOAD.time_delay = 0.05
				timer.set_wait_time(LOAD.time_delay)
				timer.start()
				yield(get_node("Timer"), "timeout")

# Temporisation
			print("Temporisation : 0.75 seconde(s)")
			timer.set_wait_time(0.75)
			timer.start()
			yield(get_node("Timer"), "timeout")
			print("Fin du timer")
			print("Fin de la ligne")

# Clos la boucle et passe au next
		#AUTO SAVE
		if LOAD.currentDial == LOAD.firstDial:
			print("Auto-Sauvegarde")
			unixTime = OS.get_unix_time()
			LOAD.dataDial = LOAD.currentDial
			LOAD.dataRep = null
			LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
			system_save()
		print("Fin du dialogue")
		LOAD.currentDial = LOAD.dial[LOAD.currentDial].next
		LOAD.time_delay = LOAD.dial[LOAD.currentDial].time
		print("Lancement du timer",LOAD.time_delay," seconde(s)")
		LOAD.currentNextTime = OS.get_unix_time() + int(LOAD.time_delay)
		LOAD.launch = 1
		#status()
		if LOAD.dial[LOAD.currentDial].ref == 1:
			print("Auto-Sauvegarde")
			unixTime = OS.get_unix_time()
			LOAD.dataDial = LOAD.currentDial
			LOAD.dataRep = null
			LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
			if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
				bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
			LOAD.actualBGSound = bg_sound
			system_save()
			status()

									## REPONSES ##
# Réponses
# Gestion des dialogues de ref 2 [REPONSES CHOIX MULTIPLES]
	if LOAD.dial[LOAD.currentDial].ref == 2 :
		print("#### DIALOGUES REF : 2 ####")
		print("Création de ",LOAD.dial[LOAD.currentDial].content.size()," bouton(s)")
		for i in range(LOAD.dial[LOAD.currentDial].content.size()):
			print("Création du bouton n°",LOAD.dial[LOAD.currentDial].button[i])
			get_node(str("vbox/Bot/VBoxBot/Bouton",i,"/Label",i)).set_text(str(LOAD.dial[LOAD.currentDial].button[i]))
			get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_ignore_mouse(false)
			get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set("visibility/visible",true)
		timer.stop()
		print("Fin de la création des boutons")


									## MESSAGE SYSTEM ##	

	if LOAD.dial[LOAD.currentDial].ref == 3:
		last_dial()
		# Trigger son message système
		sound = 3
		sample_msg()
		# Ecriture du message système
		for i in range(LOAD.dial[LOAD.currentDial].content.size()):
			print("Création du label")
			var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
			var label = labelbase.duplicate()
			print("Configuration du label")
			label.set_name(str("label",LOAD.currentDial))
			get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
			label.show()
			label.set_text(str(LOAD.dial[LOAD.currentDial].content[i]))
			label.set("visibility/opacity",1)

			# Auto scroll
			print("Scroll")
			yield(get_tree(), "idle_frame")
			get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
			LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
			get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
		
			# Temporisation
			timer.set_wait_time(1.25)
			timer.start()
			yield(get_node("Timer"), "timeout")


		#AUTO SAVE
		if LOAD.currentDial == LOAD.firstDial:
			print("Auto-Sauvegarde")
			unixTime = OS.get_unix_time()
			LOAD.dataDial = LOAD.currentDial
			LOAD.dataRep = null
			LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
			system_save()
		print("Fin du dialogue")
		LOAD.currentDial = LOAD.dial[LOAD.currentDial].next
		LOAD.time_delay = LOAD.dial[LOAD.currentDial].time
		print("Lancement du timer",LOAD.time_delay," seconde(s)")
		LOAD.currentNextTime = OS.get_unix_time() + int(LOAD.time_delay)
		LOAD.launch = 1
		#status()
		if LOAD.dial[LOAD.currentDial].ref == 3:
			print("Auto-Sauvegarde")
			unixTime = OS.get_unix_time()
			LOAD.dataDial = LOAD.currentDial
			LOAD.dataRep = null
			LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
			if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
				bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
			LOAD.actualBGSound = bg_sound
			system_save()

										## BOUTONS REPONSES ##
# Boutons
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	if lastRep == LOAD.currentDial:
		button_end()
	else:
		print("Bouton n°0 activé")
		buttonPressed = 0
		button_action()

# BOUTON 1
func _on_Bouton1_pressed():
	print("Bouton n°1 activé")
	buttonPressed = 1
	button_action()

# BOUTON 2
func _on_Bouton2_pressed():
	print("Bouton n°2 activé")
	buttonPressed = 2
	button_action()

# BOUTON 3
func _on_Bouton3_pressed():
	print("Bouton n°3 activé")
	buttonPressed = 3
	button_action()

############################### LES FONCTIONS ###############################
# Toutes les fonctions utiles
# Fonctions

# Nettoyage des boutons inutiles
# Clean
func clean():
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	print("Suppression des boutons")
	for i in range(4):
		get_node(str("vbox/Bot/VBoxBot/Bouton",i,"/Label",i)).set_text("")
		get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set_ignore_mouse(true)
		get_node(str("vbox/Bot/VBoxBot/Bouton",i)).set("visibility/visible",false)
	return

# Button Action
func button_action():
	
	# AUTO SAVE
	LOAD.dataDial = LOAD.currentDial
	LOAD.dataRep = buttonPressed
	LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
	#if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
	#	bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
	LOAD.actualBGSound = bg_sound
	system_save()
# Trigger son message envoyé
	sound = 2
	sample_msg()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.dial[LOAD.currentDial],buttonPressed))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",LOAD.dial[LOAD.currentDial].content[buttonPressed])
	label.set_text(str(LOAD.dial[LOAD.currentDial].content[buttonPressed]))

	LOAD.currentDial = LOAD.dial[LOAD.currentDial].next[buttonPressed]
	LOAD.time_delay = LOAD.dial[LOAD.currentDial].time
	#AUTO SAVE
	LOAD.dataDial = LOAD.currentDial
	LOAD.dataRep = null
	LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
	LOAD.currentNextTime = LOAD.dataNextTime
	if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
		bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
	LOAD.actualBGSound = bg_sound
	system_save()
	LOAD.launch = 1

	print("Nettoyage des boutons")
	clean()

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
		label.set_size(Vector2(925,170))
		label.set("rect/min_size",Vector2(925,170))
	elif labelsize == 4:
		label.set_size(Vector2(925,230))
		label.set("rect/min_size",Vector2(925,230))
	elif labelsize == 5:
		label.set_size(Vector2(925,290))
		label.set("rect/min_size",Vector2(925,290))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
# Affichage Smoothie
	print("Affichage")
	visible = 0
	for i in range(9):
		label.set("visibility/self_opacity",visible)
		visible = visible + 0.10
		time_delay = 0.05
		timer.set_wait_time(time_delay)
		timer.start()
		yield(get_node("Timer"), "timeout")
	status()
	return

# Bouton de fin (retour menu)
func button_end():
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	get_tree().change_scene("res://scn/menu.tscn")

# Status
func status():
# Status de l'interlocuteur
	print("Status de l'interlocuteur")
	# En ligne
	if LOAD.time_delay <= 30:
		statusText = LOAD.gameText[0]
		led = "res://img/LED_enligne.png"
		status = 1
	# Occupé
	elif LOAD.time_delay > 30 and LOAD.time_delay <= 180:
		statusText = LOAD.gameText[1]
		led = "res://img/LED_occupe.png"
		status = 2
	# Absent
	elif LOAD.time_delay > 180 and LOAD.time_delay <= 300:
		statusText = LOAD.gameText[2]
		led = "res://img/LED_absent.png"
		status = 3
	# Hors Ligne
	elif LOAD.time_delay > 300:
		statusText = LOAD.gameText[3]
		led = "res://img/LED_horsligne.png"
		status = 4

	# Vérification du changement de status
	if status != statusNext:
		message_system()
		statusNext = status
	return

# Message système status interlocuteur
func message_system():
	# Trigger son message système
	sound = 3
	sample_msg()
	# Modification de la LED
	get_node("vbox/Top/LED").set_texture(load(led))
	# Message système
	print("Modification vignette status")
	get_node("vbox/Top/Etat").clear()
	get_node("vbox/Top/Etat").add_text(str(LOAD.gameText[5]," : ",statusText))
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.currentDial))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	label.set_text(str(LOAD.gameText[6],statusText))
	
	# Affichage smoothie
	print("Affichage")
	label.set("visibility/opacity",1)
	#if visible == 0:
	#	for i in range(10):
	#		label.set("visibility/opacity",visible)
	#		visible = visible + 0.10
	#		time_delay = 0.05
	#		timer.set_wait_time(time_delay)
	#		timer.start()
	#		yield(get_node("Timer"), "timeout")
	#else:
	#	label.set("visibility/opacity",1)

	# Temporisation
	timer.set_wait_time(0.75)
	timer.start()
	yield(get_node("Timer"), "timeout")

	# Auto scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
	return



# Reset Save
# Reset de la sauvegarde
func _on_resetSave_pressed():
	get_node("Popup").popup()

# System Save
# SYSTEME DE SAUVEGARDE
func system_save():
	print("Auto-Sauvegarde")
	LOAD.saveDial.push_back(LOAD.dataDial)
	LOAD.saveRep.push_back(LOAD.dataRep)
	LOAD.saveNextTime.push_back(LOAD.dataNextTime)
	print(LOAD.saveDial)
	print(LOAD.saveRep)
	print(LOAD.saveNextTime)
	data = {"_Save" : {"dial" : LOAD.saveDial,"rep" : LOAD.saveRep, "nexttime" : LOAD.saveNextTime, "actualBGSound" : LOAD.actualBGSound}}
	var file = File.new()
	#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
	file.open(str("user://save",LOAD.scenarioFile,".json"), File.WRITE)
	file.store_line(data.to_json())
	file.close()
	return

# System Time
func system_time():
	# Récupération de l'heure du système
	var timeSys = OS.get_datetime_from_unix_time(LOAD.saveTime)
	var hourSys = timeSys.hour
	var minuteSys = timeSys.minute
	var secondSys = timeSys.second
	hourSys = hourSys + (calcultime)

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

	LOAD.timeIG = str(hourIG,":",minuteIG,":",secondIG)
	return

# Vérification FIN
func last_dial():
	if LOAD.currentDial == LOAD.lastDial:
		lastRep = LOAD.dial[LOAD.currentDial].next
		print(str("LASTREP : ",lastRep))
		if LOAD.loadChapter >= LOAD.chapterSave:
			LOAD.chapterSave = LOAD.chapterSave+1
			LOAD.data = {"_SaveGlobal" : {"chapter" : LOAD.chapterSave}}
			var file = File.new()
			#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
			file.open("user://saveglobal.json", File.WRITE)
			file.store_line(LOAD.data.to_json())
			file.close()
	return

# Système de sample MESSAGES
func sample_msg():
	if sound == 1:
		get_node("SampleMSG").play("msg_received")
	elif sound == 2:
		get_node("SampleMSG").play("msg_send")
	elif sound == 3:
		get_node("SampleMSG").play("msg_sys")
	return

# Système de trigger son
func trigger_sound():
	triggerName = str(LOAD.dial[LOAD.currentDial].sound[1])
	triggerVol = LOAD.dial[LOAD.currentDial].sound[2]
	get_node("SampleTRG").set_default_volume_db(triggerVol)
	get_node("SampleTRG").play(triggerName)

# Système de sons d'ambiance (background sound)
func background_sound():
	get_node("SampleBKG").set_default_volume_db(bg_sound_vol)
	get_node("SampleBKG").play(bg_sound)
	return

# System Exit
func system_exit():
	var nextDial = LOAD.dial[LOAD.currentDial].next
	if LOAD.dial[LOAD.currentDial].ref == 1 and LOAD.dial[nextDial].ref == 1:
		print("Auto-Sauvegarde")
		LOAD.time_delay = LOAD.dial[nextDial].time
		LOAD.dataDial = nextDial
		LOAD.dataRep = null
		LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
		if LOAD.dial[LOAD.currentDial].bgsound[0] == 1:
			bg_sound = str(LOAD.dial[LOAD.currentDial].bgsound[1])
		LOAD.actualBGSound = bg_sound
		system_save()

func _notification(notification_signal):
	if notification_signal == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		system_exit()

func _on_Reset_pressed():
	Directory.new().remove(str("user://save",LOAD.scenarioFile,".json"))
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	LOAD._ready()
	LOAD._load_chapter()
	get_tree().reload_current_scene()
	
func _on_Site_pressed():
	OS.shell_open("http://www.chroniquesdetalos.com")

func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/ChroniquesTalos")

func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/chroniquesdetalos/")

func _on_Youtube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCi_4enQ0P4U7XKdcP9340cg")

func _on_Retour_pressed():
	get_node("Popup").hide()

func _on_Quitter_pressed():
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	get_tree().change_scene("res://scn/menu.tscn")
