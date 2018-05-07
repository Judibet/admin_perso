#!/bin/bash
# VARIABLES #
 journal="${HOME}/scripts/logs/rsync_sauv.log"									# Journal d'évènements
 compte="${USER}"												# Nom du compte utilisateur acutel
 poste="${HOSTNAME}"												# Nom d'hôte du poste utilisé
 cle="jvlinux"													# Clé publique à utiliser
 serveur="ntx-010b"												# Serveur de sauvegarde
 sourcea="${HOME}"												# Répertoire à sauvegarder
 exclure="${HOME}/.exclusions.txt"										# Liste d'exclusions
 #destination="-e ssh -i $HOME/.ssh/$cle $serveur:/srv/dev-disk-by-label-Donnees/Sauvegardes/$poste/home"	# Destination de sauvegarde (non utilisée)
 destination="/media/nfssauvegardes/home"									# Destination de sauvegarde
 sauv="/media/nfssauvegardes/_SAUV/$(date +%d-%m-%Y)"								# Backup des fichiers supprimés
 partiel="/media/nfssauvegardes/_part-${compte}"								# Destination de sauvegarde non terminée
 coderr="0"													# Code erreur

# SCRIPT
 echo -e "\033[01;36mSauvegarde du dossier personnel de \"${compte}\" en cours...\033[0m\n"
# Avec sauvegardes
 rsync ${sourcea} ${destination}/ --backup --backup-dir=${sauv} --partial-dir=${partiel} --delete --filter "- ~" --filter "- lost+found/" --filter "- .Xauthority" --exclude-from=${exclure} --progress -arHpogtWzEAXv | tee ${journal}
 coderr=${?}
# Sans sauvegarde
 #rsync $sourcea $destination/ --partial-dir=$partiel --delete --filter "- ~" --filter "- lost+found/" --filter "- .Xauthority" --exclude-from=$exclure --progress -arHpogtWzEAXvh | tee $journal
 echo -e "\033[01;36mSauvegarde du dossier personnel de \"${compte}\" terminée !\033[0m\n"

# FIN
 exit ${coderr}
 
