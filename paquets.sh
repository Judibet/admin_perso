#!/bin/sh
## LISTE DES PAQUETS INSTALLÉS ##
## Par Judibet (personnalisé)  ##

## VARIABLES ##
REPERTOIRE="/media/sauvegardes/Kubuntu"
VERSION="3.0"

fuction titre(){
 echo RÉINSTALLATION DES PAQUETS DU SYSTÈME && echo ""
}


# Pilotes
function pilotes(){
 echo "Installation des pilotes clavier / souris Roccat :"
 sudo apt-get install -y --force-yes roccat-tools
}


# Installation du pilote d'impression
function imprimante(){
 echo "Installation des pilotes de d'impression Samsung :"
 sudo sh $REPERTOIRE/uld/install.sh
}


## Bureautique ##
function bureautique(){
 echo "Installation des applications bureautiques :"
 #sudo apt-get install -y gnucash					# Logiciel de gestion de gestion financière
 sudo apt-get install -y kde-thumbnailer-openoffice			# Apperçu KDE des documents OpenOffice
 sudo apt-get install -y kmymoney					# Logiciel de gestion des comptes
 sudo apt-get install -y libreoffice-base				# Édition de bases de données
 sudo apt-get install -y libreoffice-l10n-fr				# Pack de langue anglais pour OpenOffice
 sudo apt-get install -y libreoffice-pdfimport			        # Permet d'éditer les fichiers PDF
 sudo apt-get remove -y libreoffice-draw				# Permet de faire des dessins
 sudo apt-get remove -y libreoffice-math	        		# Édition d'équations graphiques
}


## Compression et archive ##
function archivage(){
 echo "Installation des applications de compression et archivage :"
 sudo apt-get install -y cabextract					# Extraction d'archives CAB
 sudo apt-get install -y p7zip-full					# Extraction d'archives 7z
 sudo apt-get install -y unace-nonfree					# Extraction d'archives ACE
 sudo apt-get install -y unrar-free					# Extraction d'archives RAR
}


## Développement ##
function developpement(){
 echo "Installation des applications de développements :"
 sudo apt-get install -y autoconf					# Outils GNU autotools
 sudo apt-get install -y automake					# Outils GNU autotools
 sudo apt-get install -y automake1.11					# Outils GNU autotools
 sudo apt-get install -y build-essential					# Paquet contenant la base de la programmation !
 sudo apt-get install -y cmake
 sudo apt-get install -y curl						# Dépendance de Steam : bibliothèque de requêtes d'URL
 sudo apt-get install -y emacs						# Editeur de texte avancé, spécial programmation !
 sudo apt-get install -y git						# Permet de conserver la version de ses scripts / codes sources
 sudo apt-get install -y sun-java6-jdk					# Applet de développement Java
}


## Internet et réseaux ##
function internet(){
 echo "Installation des applications pour Internet :"
 sudo apt-get install -y adobe-flashplugin				# Lecteur Flash
 sudo apt-get install -y aircrack-ng					# Piratage Wi-Fi
 #sudo apt-get install -y amsn						# MSN Messenger sous Linux !
 #sudo apt-get install -y amule						# Téléchargement P2P sur eDonkey
 sudo apt-get install -y chromium-browser				# Google Chrome (version libre)
 #sudo apt-get install -y dhcp3-server					# Attribue dynamiquement les adresses IP
 sudo apt-get install -y etherwake					# Wake On Lan
 sudo apt-get install -y filezilla					# Client FTP graphique
 sudo apt-get install -y firefox					# Un super navigateur Internet !
 sudo apt-get install -y firefox-locale-fr				# Langue français pour Firefox
 #sudo apt-get install -y firestarter					# Un super pare-feux !
 #sudo apt-get install -y ipx						# Protocole IPX
 sudo apt-get install -y flashplugin-installer				# Lecteur Flash
 #sudo apt-get install -y flashplugin-nonfree				# Lecteur Flash (faire un scan des plugins pour Konqueror)
 sudo apt-get install -y google-talkplugin				# Vidéo pour Google Talk
 sudo apt-get install -y iperf						# Test des performances réseau
 sudo apt-get install -y kget						# Gestionnaire de téléchargements pour Konqueror
 #sudo apt-get install -y krbf						# Partage du bureau à distance
 #sudo apt-get remove -y kopete						# Messagerie instantanée
 #kopete-facebook							# Facebook Messenger dans Kopete !
 # LAMP (dans l'ordre) #
 sudo apt-get install -y apache2 apache2-doc mysql-server php5 libapache2-mod-php5 php5-mysql phpmyadmin
 # Mettre les logs Apache en RAM
 sudo update-rc.d apache2-tmpfs defaults 90 10 # Exexuction du script de mise en cache avant le lancement d'Apache
 sudo a2enmod rewrite proxy proxy_html headers # Activation de modules d'Apache
 sudo a2enmod deflate # Activer la compression
 sudo apache2 restart
 # Mettre MySQL en RAM
 #sudo service mysql stop
 #sudo update-rc.d mysql-tmpfs defaults 18 22 # Exexuction du script de mise en cache avant le lancement de MySQL
 #sudo service mysql start
 # Première base de donnée
 sh $REPERTOIRE/mysqlconf.sh
 #sudo apt-get install -y libsnack2 #Activation du microphone pour aMSN
 #linphone								# SIP sous Linux
 sudo apt-get install -y lynx						# Un navigateur en mode console !
 sudo apt-get install -y mplayer-nogui					# MPlayer en mode console
 sudo apt-get install -y mumble						# Outil de communication pour les joueurs !
 sudo apt-get install -y nfs-common					# Prise en charge du réseau NFS
 sudo apt-get install -y network-manager-kde				# Configuration graphique du réseau
 sudo apt-get install -y nmap						# Sniffeur
 sudo apt-get install -y pavucontrol					# Permet de configurer le micro sur Skype
 # sudo apt-get install -y pidgin					# Messagerie instantannée
 # sudo apt-get install -y pidgin-facebookchat				# Facebook depuis Pidgin
 # sudo apt-get install -y pidgin-gmchess				# Jeud d'échec sur Pidgin
 # sudo apt-get install -y pidgin-hotkeys				# Raccourcis Pidgin
 # sudo apt-get install -y pidgin-lastfm				# Last FM sur Pidgin
 # sudo apt-get install -y pidgin-musictracker				# Affiche la musique en écoute sur Pidgin
 # sudo apt-get install -y pidgin-skype					# Ajout de Skype sur Pidgin
 # sudo apt-get install -y pidgin-themes				# Possibilité de créer des thèmes sur Pidgin
 sudo apt-get install -y proftpd-basic					# Serveur FTP
 sudo apt-get install -y samba						# Partage de fichiers en réseau
 sudo cp $REPERTOIRE/etc/samba/smb.conf /etc/samba/			# Restauration de la configuration de Samba
 sudo apt-get install -y ssh						# Installation du serveur SSH
 sudo apt-get install -y skype						# Téléphonie par Internet et voie sur IP
 #sudo apt-get install -y sun-java6-plugin				# Plugin Java pour navigateurs
 #sudo apt-get install -y teamspeak-client				# Client TeamSpeak (parler entre potes entre hors serveur)
 sudo apt-get install -y thunderbird					# Client de messagerie...
 sudo apt-get install -y thunderbird-locale-fr				# ...en français bien sûr !
}


## Jeux ##
function jeux(){
 echo "Installation des jeux :"
 sudo apt-get install -y alien-arena					# Un Quake Like dans la peau d'aliens !
 sudo apt-get install -y alien-arena-server				# Possibilité de créer des serveurs Alien Arena
 sudo apt-get install -y chromium					# Un jeu de vaisseau arcade
 #ioquake3								# Quake 3 amélioré !
 sudo apt-get install -y mupen64plus					# Un émulateur Nintendo 64
 sudo apt-get install -y mupen64plus-qt                                  # Et son interface graphique...
 sudo apt-get install -y openarena					# La renaîssance de Quake 3 Arena !
 sudo apt-get install -y openarena-server				# Possibilité de créer des serveurs Open Arena
 #pcsx									# Émulateur PlayStation
 sudo apt-get install -y pingus						# Lemmings version Linux !
 sudo apt-get install -y pokerth						# Poker sur Linux !
 #psemu-drive-cdrmooby							# Prise en charge des images CD PlayStation pour PCSX
 #psemu-input-omnijoy							# Plugin pour controlleurs pour PCSX
 #psemu-video-x11							# Plugin graphique pour PCSX
 sudo apt-get install -y steam-launcher libdbusmenu-gtk4:i386		# Steam et librairie pour retirer bug menu contextuel
 sudo apt-get install -y vbaexpress					# Émulateur GameBoy Advanced
 sudo apt-get install -y wormux						# Un jeu de type "Worm" en plus marrant !
 #sudo apt-get install -y zsnes						# Émulateur Super Nintendo
}


## Multimédia ##
function multimedia(){
 echo "Installation des applications multimédias :"
 sudo apt-get install -y abcde						# Encodeur CD sous terminal
 sudo apt-get install -y audacity					# Edition de pistes audio
 sudo apt-get install -y avidemux					# Découpeur vidéo
 sudo apt-get install -y avidemux-plugins-common				# Plugins pour Avidemux
 sudo apt-get remove -y brasero						# Désinstallation du logiciels de gravure par défaut de Gnome
 sudo apt-get install -y cinelerra-cv                                    # Logiciel de montage vidéo professionnel
 sudo apt-get install -y desktop-file-utils				# Utile pour l'installation de Mobile Media Converter
 sudo apt-get install -y djmount						# Client UPnP
 #sudo apt-get install -y easytag						# Un taggueur pour fichiers audio
 sudo apt-get install -y faac						# Codec AAC
 sudo apt-get install -y faad						# Codec M4A
 sudo apt-get install -y flac						# Codec FLAC
 sudo apt-get install -y gstreamer0.10-ffmpeg				# Permet de lire les vidéos MP4
 sudo apt-get install -y gstreamer1.0-plugins-bad-faad			# 
 sudo apt-get install -y gstreamer1.0-plugins-ugly			# Permet de lire les fichiers MP3
 sudo apt-get install -y gstreamer1.0-libav				# 
 sudo apt-get install -y icedax						# Conversion CDA
 sudo apt-get install -y inkskape					# Déssins vectoriels
 sudo apt-get install -y kid3                                            # Un taggueur pour fichiers audio
 sudo apt-get install -y kipi-plugins					# Modules complémentaires pour Gwenview
 sudo apt-get install -y kstreamripper					# Enregistrement de flux audio
 #sudo apt-get install -y kmplayer					# Lecteur multimédia pour KDE
 sudo apt-get install -y gimp						# Edition d'images
 sudo apt-get install -y gimp-data-extras				# Plugins pour Gimp
 sudo apt-get install -y gimp-plugin-registry				# 
 sudo apt-get install -y gimp-ufraw					# Prise en compte du format RAW pour Gimp
 cp $REPERTOIRE/plugins_gimp/arrow.scm	$HOME/.gimp-2.6/scripts/
 cp $REPERTOIRE/plugins_gimp/arrow.scm	$HOME/.gimp-2.8/scripts/
 sudo apt-get install -y hal                                             # Permet de regarder des vidéo Google Play
 sudo apt-get install -y lame						# Codec LAME (s'utilise avec sox pour la conversion OGG)
 #libarts1-xine					# Apperçu des MP3 au survol
 sudo apt-get install -y libavcodec-unstripped-52			# Permet de lire d'autre formats multimédias
 sudo apt-get install -y libdvdnav4					# Lecture des DVD avec menus
 sudo apt-get install -y libgstreamer-plugins-bad1.0-0			# 
 sudo apt-get install -y libk3b6-extracodecs				# Des plugins additionnels pour K3B
 sudo apt-get install -y libxine1-ffmpeg					# Support et lecture MP3
 sudo apt-get install -y libxine1-all-plugins				# Support des formats Windows
 sudo apt-get install -y moodbar						# Humeurs pour Amarok
 sudo apt-get install --install-recommends -y pipelight-multi		# Pour faire fonctionner Silverlight sous Linux
 sudo apt-get install -y obs-studio                                      # Permet de faire du streaming vidéo sur Twitch et YouTube
 sudo pipelight-plugin --update
 #sudo pipelight-plugin --enable flash
 sudo pipelight-plugin --enable silverlight                              # Active Silverlight
 sudo pipelight-plugin --unlock shockwave                                # Débloque le plugin Shockwave
 sudo pipelight-plugin --enable shockwave                                # Active le plugin Shockwave
 sudo pipelight-plugin --enable unity3d                                  # Active le mode Unity3D de Silverlight
 sudo pipelight-plugin --enable widevine                                 # Active la possibilité de voir les vidéos Silverlight protégés par DRM
 sudo pipelight-plugin --create-mozilla-plugins                          # Créer les plugins Piplelight pour Mozilla
 #sudo apt-get install -y mplayer					# Un super lecteur multimedia !
 #sudo apt-get install -y realplayer					# Lecteur multimédia Real Player
 sudo apt-get install -y regionset					# Lecture des DVD multi-régions
 sudo apt-get remove -y rhythmbox					# Désinstallatin du lecteur multimédia de Gnome
 sudo apt-get install -y soundkonverter					# Conversion audio
 sudo apt-get install -y sox						# Conversion OGG vers MP3 (s'utmon					# Prise en charge duilise avec lame)
 sudo apt-get install -y speex						# Codec Speex
 sudo apt-get install -y spotify-client                                  # Lecteur multimédia en ligne
 sudo apt-get install -y timidity					# Support MIDI
 sudo apt-get install -y transcode					# Encodage de vidéos RAW
 sudo apt-get install -y vorbis-tools					# Codec OGG Vorbis
 #sudo apt-get install -y w32codecs					# De nombreux codecs Windows (WMA, RealAudio etc...)
 sudo apt-get install -y wavpack						# Codec WavePack
 sudo apt-get install -y xine-plugin					# Permet de voir des vidéos avec un navigateur
}


## Utilitaires ##
function outils(){
 echo "Installation des utilitaires :"
 sudo apt-get install -y acetoneiso					# L'utilitaire le plus géant des images CD !
 sudo apt-get install -y alien						# Installation des parquets RPM
 sudo apt-get install -y android-tools-adb				# Outils pour Android
 sudo apt-get install -y bluez-btsco					# Prise en charge des casques stéréo Bluetooth
 sudo apt-get install -y bluez-pcmcia-support				# Prise en charge des cartes PCMCIA Bluetooth
 sudo apt-get install -y debian-archive-keyring				# Fixe les erreurs de clés GnuPGP
 #sudo apt-get install -y disk-manager					# Configurer graphiquement les partitions
 sudo apt-get install -y flashrom					# Flasher le BIOS depuis Linux !
 sudo apt-get install -y foremost					# Permet de récupérer les éléments supprimés
 sudo apt-get install -y fuseiso						# Montage d'images ISO
 sudo apt-get install -y gnupg2						# GNU Privacy Guard
 #sudo apt-get install -y gtk-recordmydesktop				# Interface graphique pour recordmydesktop
 sudo apt-get install -y gucharmap					# Table de caractères
 sudo apt-get install -y i7z                                             # Permet d'afficher en ligne de commandes les informatiosn sur les cors du CPU ainsi que le mode turbo
 sudo apt-get install -y i7z-gui                                         # Permet d'afficher graphiquement les informations sur les cores du CPU
 sudo apt-get install -y john						# Brute Force
 sudo apt-get install -y k3b-extrathemes					# Thèmes supplémentaires pour K3b
 sudo apt-get install -y kazam                                           # Capture vidéo du bureau
 sudo cp $REPERTOIRE/usr/lib/python3/dist-packages/kazam/backend/gstreamer.py /usr/lib/python3/dist-packages/kazam/backend/
 sudo apt-get install -y kchmviewer					# Lecture des fichiers d'aide Windows
 sudo apt-get install -y kdocker						# Réduire les applications dans la barre des tâches
 sudo apt-get install -y kgpg						# Utilisation graphique du GnuPGP !
 sudo apt-get install -y krdc						# VNC pour KDE
 #sudo apt-get install -y libcv2.3					# Librairie de reconnaissance faciale
 #sudo apt-get install -y libcv-dev					# Librairie de reconnaissance faciale
 #sudo apt-get install -y multisystem					# Permet de créer des clés USB démarrables avec plusieurs systèmes
 sudo apt-get install -y nextcloud-client                                # Client Nexcloud pour Linux
 #sudo apt-get install -y numlockx					# Activation du pavé numérique
 sudo apt-get install -y obexftp						# Protocole de transfert de fichiers Bluetooth (voire Irda)
 #sudo apt-get install -y pam-face-authentication				# Reconnaissance faciale
 sudo apt-get install -y python-gpgme					# Pour Dropbox...
 #sudo apt-get install -y recordmydesktop					# Capture vidéo du bureau
 #sudo apt-get install -y gparted					# Outil de partitionnement
 #sudo apt-get install -y skanlite					# Logiciel de numérisation
 sudo apt-get install -y testdisk					# Test de partitions
 #sudo apt-get install -y unetbootin					# Utilitaire pour créer des clés USB démarrables au boot
 sudo apt-get install -y usb-creator-kde					# Utilitaire pour créer des clés USB démarrrables au boot
 sudo apt-get install -y vim						# Éditeur de textes en lignes de commandes très populaire avec coloration sytaxique
 sudo apt-get install -y wine						# Émulateur Windows
 sudo apt-get install -y wine1.6						# Wine version 1.6
 sudo apt-get install -y wine1.6-amd64					# Prise en charge 64 bits pour Wine
 sudo apt-get install -y wine1.6-i386					# prise en charge 32 bits pour Wine
 sudo apt-get install -y xdotool						# Permet d'automatiser des clics souris et entrées clavier !
 sudo apt-get install -y xterm						# Console de base, dépendance de Steam
 sudo apt-get install -y yakuake						# Console fun pour KDE
}


## ANTIVIRUS ##
function secur(){
 echo "Installation de l'antivirus :"
 sudo apt-get install -y clamav						# Antivirus
 #sudo apt-get install -y clamav-daemon					# Démon de Clamav, trop lent à mon goût...
 sudo apt-get install -y clamtk						# Interface graphique pour Clamav
 sudo apt-get install -y inotify-tools					# Librairie pour scan automatique
 sudo apt-get install -y libnotify-bin					# Librairie pour scan automatique
}


## DIVERS ##
function divers(){
echo "Installation des applications supplémentaires :"
 sudo apt-get install -y exfat-fuse					# Permet de lire les cartes formatées exFAT
 sudo apt-get install -y exfat-utils					# Permet de lire les cartes formatées exFAT
 sudo apt-get install -y grub-customizer					# Permet de personnaliser Grub
 sudo apt-get install -y gsfonts-x11					# Polices Ghostscript sous x11
 sudo apt-get install -y kdenetwork-dbg					# Librairie de débuguage
 #sudo apt-get install -y libqt4-dbg					# Librairie de débuguage
 sudo apt-get install -y libtiff4					# Librairie TIFF
 sudo apt-get install -y libxi-dev					# Permet de debugguer Genymotion
 sudo apt-get install -y libxmu-dev					# Permet de debugguer Genymotion
 sudo apt-get install -y lm-sensors					# Permet d'avoir le niveau des sondes de température
 sudo apt-get install -y lsb						# Support Linux Standard Base 3.2
 sudo apt-get install -y mesa-utils					# Utilitaires pour tester la carte vidéo
 sudo apt-get install -y mesa-utils-extra				# Utilitaires pour tester la carte vidéo
 sudo apt-get install -y msttcorefonts					# Polices Microsoft
 #sudo apt-get install -y nvidia-common					# Pilote générique Nvidia
 #sudo apt-get install -y nvidia-current					# Derniere version du pilote Nvidia
 sudo apt-get install -y nvidia-settings					# Permet de configurer graphiquement la carte vidéo Nvidia
 #sudo apt-get install -y oem-audio-hda-daily-lts-vivid-dkms		# Pilotes audio Intel a170
 #sudo apt-get install -y ubuntuone-installer				# Ubuntu One, le cloud
 #sudo apt-get install -y ubuntuone-control-panel			# Panneau de controle pour Ubuntu One
 sudo apt-get install -y virtualbox virtualbox-qt virtualbox-dkms	# Émulateur PC/Mac
 version=$(VBoxManage --version|cut -dr -f1|cut -d'_' -f1) && sudo wget http://download.virtualbox.org/virtualbox/$version/VBoxGuestAdditions_$version.iso -O /usr/share/virtualbox/VBoxGuestAdditions.iso
 ## Support AMR/3GP (non fonctionnel pour le moment) ##
 #quilt dpkg-dev libimlib2-dev texi2html liblame-dev libfaad-dev libmp4v2-dev libfaac-dev libxvidcore4-dev debhelper libogg-dev libvorbis-dev liba52-dev libdts-dev libsdl1.2debian-all libraw1394-dev libdc1394-13-dev libtheora-dev libgsm1-dev libx264-dev x264 libxvidcore4
 sudo apt-get install -y zram-config                                     # Compression de la mémoire RAM

 # Pour Microsoft Office 32 bits
 #sudo apt-get install -y ia32-libs
 #sudo apt-get install -y libgl1-mesa-dev
 #sudo apt-get install -y libgl1-mesa-glx:i386
 #sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/mesa/libGL.so
 #sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so /usr/lib/i386-linux-gnu/libGL.so
}


# Installations manuelles et attributions des droits
## Installations manuelles, copies et liens symboliques
function autres(){
 echo "Installations d'applicationfs diverses :"
 sudo dpkg -i $REPERTOIRE/Paquets/*.deb | sudo cp -r $REPERTOIRE/usr/share/* /usr/share | bzip2 -d $REPERTOIRE/Paquets/*.bzip2 | tar xvf $REPERTOIRE/Paquets/*.tar | sudo mv $REPERTOIRE/Paquets/bluegriffon /usr/share | sudo ln -s /usr/share/bluegriffon/bluegriffon /usr/bin/bluegriffon | sudo cp -r $REPERTOIRE/etc/init.d/* /etc/init.d/
 #sudo alien -i $REPERTOIRE/Paquets/*.rpm
 #sudo sh $REPERTOIRE/Paquets/*.run
 ## Liens symboliques pour débugguer le sript Ripple FX et pour avoir roccateventhandler au démarrage
 sudo ln -s /usr/share/roccat/ryos_effect_modules/ripple.lua /usr/share/roccat/ryos_effect_modules/ripple.lc
 sudo ln -s /etc/inid.d/roccateventhandler /etc/rc4.d/roccateventhandler
 sudo ln -s /etc/inid.d/roccateventhandler /etc/rc5.d/roccateventhandler
 sudo ln -s /etc/inid.d/roccateventhandler /etc/rc6.d/roccateventhandler
 sudo ln -s /etc/inid.d/roccateventhandler /etc/rcS.d/roccateventhandler
 ## Attribution des droits
 sudo chmod -R +rx /usr/share bluegriffon genymotion TeamSpeak*
 sudo chmod +x /etc/init.d/*
 ## Attribution des groupes
 sudo usermod -G cdrom -a chris
 sudo usermod -G floppy -a $USER,chris
 sudo usermod -G roccat -a $USER,chris
 sudo usermod -G tape -a $USER,chris
 sudo usermod -G vboxusers -a $USER,chris



# Débugguer Roccat-Tools
sudo ln -s /usr/share/roccat/ryos_effect_modules/ripple.lua /usr/share/roccat/ryos_effect_modules/ripple.lc
}


# Dernières mises à jour...
function finalisation(){
 echo "Finalisation et mises à jours..."
 sudo apt-get install -f # Permet d'installer les dépendances manquantes
 sudo apt-get update -y && apt-get upgrade -y && sudo apt-get dist-upgrade -y
}

function fin(){
 echo RÉINSTALLATION DES PAQUETS DU SYSTÈME TERMINÉE && echo ""
 echo "Faire un sudo apt-get install -y nvidia-370 après redémarrage du système."
 #pause
 exit 0
}

## DÉBUT ##
 titre
 echo Mise à jour en cours...
 sudo apt-get update -y
 pilotes
 imprimantes
 bureautique
 archivage
 developpement
 internet
 jeux
 multimedia
 outils
 secur
 divers
 autres
 finalisation

## FIN ##
 fin

