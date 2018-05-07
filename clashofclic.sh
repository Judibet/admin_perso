#!/bin/bash
 # Constantes / Variables
 clan="Kux de Noisy"
 jeu="Clash of Clans"
 auteur="Judibet"
 version="1.2b"
 robot="xdotool"
 temps="120"

 clear

 echo "Script de clic automatique pour Clash of Clans pour le clan ${clan} !"
 echo "Auteur du script : ${auteur}"
 echo "Version du script : ${version}"
 echo "C'est un bon plan pour ne pas se faire attaquer en ton abscence émoticône grin !"
 echo ""

# Expérimental : test si l'application est déjà installée
 if [ $(dpkg-query -W -f='${Status}' xdotool 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  echo "Le paquet ${robot} n'a pas été détecté."
  echo "Ce paquet est nécessaire au fonctionnement du robot."
  echo "Installation de ${robot} en cours..."
  sudo apt-get install -y ${robot};
  echo "Installation de ${robot} terminé !"
 fi

 echo "Execution du robot."
 echo "Veuillez laisser le jeu ${jeu} ouvert dans la machine virtuelle."
 echo ""
 echo "*** Pour arrêter l'execution du script : faire CTRL Z ***"

 # Boucle infinie
 while [ true ] ; do
 # Les commandes en commentaires permettent de séléctionner la fenêtre de la machine virtuelle mais ça ne fonctionne pas chez moi...
 #WID=`xdotool search --class "Genymotion" | head -1`
 #xdotool windowactivate --sync $WID

 #WIDS=`xdotool search --onlyvisible --name "Genymotion"`
 #for id in $WIDS; do
 #  xdotool windowactivate --sync $WIDS
 #done
 xdotool mousemove 700 550                              # Déplacement du curseur
 xdotool click 1                                        # Clic
 sleep ${temps}                                         # Attendre 2 minutes
 done

 echo "Au revoir !"
 exit 0
