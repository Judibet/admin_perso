#!/bin/bash
 set +x
 # Constantes / Variables
 clan="Kux de Noisy"
 jeu="Clash of Clans"
 auteur="Judibet"
 version="1.5b"
 robot="xdotool"
 temps="120"

# Titre
function titre(){
 clear
 echo "Script de clic automatique pour Clash of Clans pour le clan ${clan} !"
 echo "Auteur du script : ${auteur}"
 echo "Version du script : ${version}"
 echo "C'est un bon plan pour ne pas se faire attaquer en ton abscence :D !"
 echo ""
}

# Expérimental : test si l'application est déjà installée
function testrobot(){
 if [ $(dpkg-query -W -f='${Status}' xdotool 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  echo "Le paquet ${robot} n'a pas été détecté."
  echo "Ce paquet est nécessaire au fonctionnement du robot."
  echo "Installation de ${robot} en cours..."
  sudo apt-get install -y ${robot};
  echo "Installation de ${robot} terminé !"
 fi
}

# Fonction principale
function script_principal(){
 echo "Execution du robot."
 echo "Veuillez laisser le jeu ${jeu} ouvert dans la machine virtuelle."
 echo ""
 echo "*** Pour arrêter l'execution du script : faire CTRL Z ***"
 # Boucle infinie
 while [ true ]; do
 # Les commandes en commentaires permettent de séléctionner la fenêtre de la machine virtuelle mais ça ne fonctionne pas chez moi...
 #WID=`xdotool search --class "Genymotion" | head -1`
 #xdotool windowactivate --sync $WID

 #WIDS=`xdotool search --onlyvisible --name "Genymotion"`
 #for id in $WIDS; do
 #xdotool windowactivate --sync $WIDS
 #done
 xdotool mousemove 700 550				# Déplacement du curseur
 xdotool click 1					# Clic
 sleep ${temps}						# Attendre 2 minutes
 done
}

# Test des paramètres d'entrée
function testparams(){
 params="${@}"
  case "${params}" in
  "--help" | "--man" | "-h" )
   usage "manuel"
  ;;
  "--usage" )
   usage "usage"
  ;;
  * )
   usage "erreur"
  ;;
  esac
}

# Usages
function usage(){
 typemsg="${*}"
  case "${typemsg}" in
   "manuel" | "manual" )
    echo "Ce script s'exécute en boucle pour effectuer des clics réguliers."
    echo "Un clic sera effectué toute les deux minutes par défaut."
    echo "Pour quitter, faire CTRL+Z."
    echo ""
    exit 0
   ;;
   "usage" )
    echo "${0}                    			# Exécution du script"
    echo "${0} -h | --help        			# Manuel d'exécution du script"
    echo "${0} --usage            			# Usage"
    echo ""
    exit 0
   ;;
   "erreur" | "error" )
    echo "Paramètre d'entrée non reconnu."
    usage "usage"
    exit 1
   ;;
   * )
    echo "Message non reconnu..."
    echo ""
    exit 2
   ;;
  esac
}

# DÉBUT
 # Test si paramètre entré ou non
 if [[ "${#}" > 0 ]]; then
  testparams "${@}"
 fi
 # Démarrage normal
 titre
 testrobot
 script_principal
 
# FIN
 echo "Au revoir !"
 exit 0

