#!/bin/bash
## LISTE DES PAQUETS INSTALLÉS ##
## Par Judibet (personnalisé)  ##

## VARIABLES ##
VERSION="3.5"															# Version du script
UTILISATEUR="${USER}"														# Utilisateur courant
LISTE_UTILISATEURS="$(echo $(getent passwd | awk -F: '999<$3 && $3<30000 && $1 != "nobody" {print $1}' | tr '\n' ','))"		# Liste des comptes utilisateurs
TEMPORAIRE="$(mktemp --tmpdir=/var/tmp)"											# Fichier temporaire
JOURNALISATION="/var/log/paquets.log"												# Journalisation
SCRIPT="$(basename ${0})"													# Nom du script
BLANCSCRIPT="$(echo ${SCRIPT} | tr 'àçéèêëîïôöùüÂÇÉÈÊËÎÏÔÖÙÜ²[:print:][:alnum:][:punct:][:blank:]' ' ')"			# Blanc sur taille du nom du script
NBPARAMS="${#}"															# Nombre de paramètres
PARAMS="${*}"															# Tous les paramètres entrés lors du lancement du script
PARAM1="${1}"															# Premier paramètre
PARAM2="${2}"															# Second paramètre
UAV=0																# Passe à 1 si affichage version ou aide

## COULEURS ET STYLES ##
DEFAUT="$(tput sgr0)"														# Aucun style
NOIR="$(tput setaf 0)"														# Texte noir
ROUGE="$(tput setaf 1)"														# Texte rouge
VERT="$(tput setaf 2)"														# Texte vert
JAUNE="$(tput setaf 3)"														# Texte jaune
BLEU="$(tput setaf 4)"														# Texte bleu
MAGENTA="$(tput setaf 5)"													# Texte magenta
CYAN="$(tput setaf 6)"														# Texte cyan
BLANC="$(tput setaf 7)"														# Texte blanc
FNOIR="$(tput setab 0)"														# Fond noir
FROUGE="$(tput setab 1)"													# Fond rouge
FVERT="$(tput setab 2)"														# Fond vert
FJAUNE="$(tput setab 3)"													# Fond jaune
FBLEU="$(tput setab 4)"														# Fond bleu
FMAGENTA="$(tput setab 5)"													# Fond magenta
FCYAN="$(tput setab 6)"														# Fond cyan
FBLANC="$(tput setab 7)"													# Texte blanc
GRAS="$(tput bold)"														# Gras
DEMI_TEINTE="$(tput dim)"													# Demi-teinte
MODESOULIGNE="$(tput smul)"													# Activer le soulignement
PASSOULIGNE="$(tput rmul)"													# Désactiver le soulignement
INVERSE="$(tput rev)"														# Inverser le style
MODEGRAS="$(tput smso)"														# Activer la mise en gras
PASGRAS="$(tput rmso)"														# Désactiver la mise en gras
SONNETTE="$(tput bel)"														# Faire sonner le PC

## FONCTIONS ##
# Affichage du titre
function AfficherTitre(){
	# Variables locales
	local Version="${1}"													# Version du script
	#
	if [[ -z "${Version}" ]]; then
		echo "${FBLEU} ${BLANC}RÉINSTALLATION DES PAQUETS DU SYSTÈME !${DEFAUT}"
	else
		echo "${FBLEU} ${BLANC}RÉINSTALLATION DES PAQUETS DU SYSTÈME ${VERSION}${DEFAUT}"
	fi
	echo
}

# Utilisation du script
function Usage(){
	# Variables locales
	local CodeMessage="${1}"												# Code message
	local AfficherAide=( "${JAUNE}Utilisations :${DEFAUT}\n"
			"${MAGENTA}${SCRIPT}${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -a, --aide${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Aide${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -l, --légé, --allégé${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation allégée${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets nécéssaires\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -n, --normal${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation normale${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets les plus utiles et pratiques\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -c, --complet${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation complète${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation de tous les paquets du pack${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -M, --complet-maj${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation complète avec montée de niveau${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation de tous les paquets du pack et migration du système${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -g, --graphique${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des pilotes graphiques et outils${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -r, --roccat${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des pilotes clavier / souris Roccat${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -p, --imprimantes-samsung${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des pilotes d'impression Samsung (action manuelle)${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -b, --bureautique${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets bureautique${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -x, --compression${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets pour compression et archivage${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -d, --developpement${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets de développement${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -D, --developpement+${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets de développement et de compilation${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -C, --compilation${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets de compilation${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -i, --internet${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets pour Internet${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -j, --jeux${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets pour le jeux-vidéo${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -m, --multimédia${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets pour le multimédia${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -H, --serveur${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets pour les serveurs${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -s, --securite${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets de sécurité${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -u, --utilitaires${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets utilitaires${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -E, --autres${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Installation des paquets non présent dans les dépôts${DEFAUT}\n"
			"\n"
			" ${MAGENTA}${BLANCSCRIPT}                              -v, --version${DEFAUT}\n"
			" ${MAGENTA}${BLANCSCRIPT}                              Version du script${DEFAUT}\n" )

	#
	UAV=1															# Le marqueur d'utilisation de l'option aide/version passe à 1
	case "${CodeMessage}" in
		"aide" )
			echo -e "${AfficherAide[*]}"
			echo
			exit 0
			;;
		"manuel" )
			#echo -e "${AfficherAide[*]}" | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | sed "s/[[:cntrl:]](B[[:cntrl:]]\[m//g" | less -M
			echo -e "${AfficherAide[*]}" | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | sed "s/[[:cntrl:]](B[[:cntrl:]]\[m//g" | less -P "Appuyez sur Q pour quitter et revenir au menu"
			InstallerPaquets "interface"
			;;
		* )
			echo -e "${AfficherAide[*]}"
			echo
			exit 1
		;;
	esac
}

# Test utilisateur
function TestUtilisateur(){
	# Variables locales
	local CodeRetour=${1}													# Code retourné par la fonction
	#
	if [[ "${USER}" =~ ^(|k|l|x|ed)ubuntu$ ]]; then
		echo "${FMAGENTA} ${CYAN}MODE TEST${DEFAUT}"
	elif [[ "${USER}" == "root" ]]; then
		echo " ${ROUGE}Merci d'utiliser ce script avec un compte utilisateur local"
		local CodeRetour=2
		TestSiErreur ${CodeRetour} "" "utilisateurs"
	elif [[ $(sudo -nv 2> '/dev/null') -ne 0 ]]; then
		echo " ${ROUGE}Merci d'utiliser ce script avec un compte ayant les droits sudo"
		local CodeRetour=3
		TestSiErreur ${CodeRetour} "" "utilisateurs"
	fi
}

# Test des paramètres
function TestParametres(){
	# Variables locales
	local Arguments=""													# Arguments entrés en paramètres du script (pour shifter)
	local Options=""													# Options entrées
	local UTitre=0														# Passe à 1 si titre déjà affiché
	local UMAJDepots=0													# Passe à 1 si dépôts déjà mis à jour
	local UAide=0														# Passe à 1 si option aide utilisée
	local ULege=0														# Passe à 1 si option légé utilisée
	local UNormal=0														# Passe à 1 si option normale utilisée
	local UComplet=0													# Passe à 1 si option complet utilisée
	local UCompletMaj=0													# Passe à 1 si option complet avec montée de version utilisée
	local UGraphique=0													# Passe à 1 si option graphique utilisée
	local URoccat=0														# Passe à 1 si option roccat utilisée
	local USamsung=0													# Passe à 1 si option samsung utilisée
	local UBureautique=0													# Passe à 1 si option bureautique utilisée
	local UCompression=0													# Passe à 1 si option compression utilisée
	local UDeveloppement=0													# Passe à 1 si option développement utilisée
	local UDeveloppementPlus=0												# Passe à 1 si option compilation utilisée
	local UInternet=0													# Passe à 1 si option internet utilisée
	local UJeux=0														# Passe à 1 si option jeux utilisée
	local UMultimedia=0													# Passe à 1 si option multimédia utilisée
	local UServeur=0													# Passe à 1 si option serveur utilisée
	local USecurite=0													# Passe à 1 si option securite utilisée
	local UUtilitaires=0													# Passe à 1 si option utilitaires utilisée
	local UAutres=0														# Passe à 1 si option autres utilisée
	local UVersion=0													# Passe à 1 si option version utilisée
	#
	for Arguments in "${@}"; do
		shift
		case "${Arguments}" in
			"--aide" )
				set -- "${@}" "-a"
				;;
			"--help" )
				set -- "${@}" "-a"
				;;
			"--lege" | "--légé" | "--allege" | "--allégé" | "--light" )
				set -- "${@}" "-l"
				;;
			"--normal" )
				set -- "${@}" "-n"
				;;
			"--complet" )
				set -- "${@}" "-c"
				;;
			"--full" )
				set -- "${@}" "-c"
				;;
			"--complet-maj" )
				set -- "${@}" "-M"
				;;
			"--full-upgrade" )
				set -- "${@}" "-M"
				;;
			"--graphique" | "--graphic" | "--graphics" )
				set -- "${@}"  "-g"
				;;
			"--roccat" | "--roccat-tools" )
				set -- "${@}" "-r"
				;;
			"--imprimantes-samsung" | "--imprimante-samsung" | "--impressions-samsung" | "--samsung-printing" | "--samsung" )
				set -- "${@}" "-p"
				;;
			"--bureautique" )
				set -- "${@}" "-b"
				;;
			"--compression" )
				set -- "${@}" "-x"
				;;
			"--developpement" )
				set -- "${@}" "-d"
				;;
			"--developpement+" )
				set -- "${@}" "-D"
				;;
			"--compilation" )
				set -- "${@}" "-C"
				;;
			"--internet" )
				set -- "${@}" "-i"
				;;
			"--jeux" | "jeux-vidéo" | "jeux-video" )
				set -- "${@}" "-j"
				;;
			"--multimédia" | "--multimedia" )
				set -- "${@}" "-m"
				;;
			"--serveur" )
				set -- "${@}" "-H"
				;;
			"--sécurité" | "--securite" )
				set -- "${@}" "-s"
				;;
			"--utilitaires" )
				set -- "${@}" "-u"
				;;
			"--autres" )
				set -- "${@}" "-E"
				;;
			"--version" )
				set -- "${@}" "-v"
				;;
			* )
				set -- "${@}" "${Arguments}"
				;;
		esac
	done
	# GetOpts
	while getopts 'abcCdEDHilgjmMnprsuvx' Options 2> '/dev/null'; do
		case "${Options}" in
			"a" )
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${UAide} -eq 0 ]]; then
						Usage "aide"
						local UAide=1
					fi
					:
				fi
				:
				;;
			"b" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UBureautique} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" >'/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "bureautique"
					local UBureautique=1
				fi
				:
				;;
			"c" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${UComplet} -eq 0 ]]; then
						if [[ ${UMAJDepots} -eq 0 ]]; then
							echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
							# Création du fichier temporaire pour y mettre les erreurs éventuelles
							if [[ ! -e "${TEMPORAIRE}" ]]; then
								touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
							fi
							if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
								sudo chown ${USER}: "${TEMPORAIRE}"															2>&0
							fi
							# Création du fichier journal
							if [[ ! -e "${JOURNALISATION}" ]]; then
								sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
							fi
							if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
								sudo chown ${USER}: "${JOURNALISATION}"															2>&0
							fi
							local UMAJDepots=1
							sudo apt-get update -qq -y														> '/dev/null'
							local CodeRetour=${?}
							TestSiErreur ${CodeRetour} "" "maj"
						fi
						InstallerPaquets "complet"
						local UComplet=1
					fi
					:
				fi
				:
				;;
			"C" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UDeveloppementPlus} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "compilation"
					local UDeveloppementPlus=1
				fi
				:
				;;
			"d" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UDeveloppement} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "developpement"
					local UDeveloppement=1
				fi
				:
				;;
			"D" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UDeveloppement} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "developpement"
					local UDeveloppement=1
				fi
				if [[ ${UDeveloppementPlus} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "compilation"
					local UDeveloppementPlus=1
				fi
				:
				;;
			"E" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UAutres} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "autres"
					local UAutres=1
				fi
				:
				;;
			"g" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UGraphique} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "graphique"
					local UGraphique=1
				fi
				:
				;;
			"H" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UServeur} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "serveur"
					local UServeur=1
				fi
				:
				;;
			"i" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UInternet} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "internet"
					local UInternet=1
				fi
				:
				;;
			"j" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UJeux} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "jeux"
					local UJeux=1
				fi
				:
				;;
			"l" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${ULege} -eq 0 ]]; then
						if [[ ${UMAJDepots} -eq 0 ]]; then
							echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
							# Création du fichier temporaire pour y mettre les erreurs éventuelles
							if [[ ! -e "${TEMPORAIRE}" ]]; then
								touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
							fi
							if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
								sudo chown ${USER}: "${TEMPORAIRE}"															2>&0
							fi
							# Création du fichier journal
							if [[ ! -e "${JOURNALISATION}" ]]; then
								sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
							fi
							if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
								sudo chown ${USER}: "${JOURNALISATION}"															2>&0
							fi
							local UMAJDepots=1
							sudo apt-get update -qq -y														> '/dev/null'
							local CodeRetour=${?}
							TestSiErreur ${CodeRetour} "" "maj"
						fi
						InstallerPaquets "légé"
						local ULege=1
					fi
					:
				fi
				:
				;;
			"m" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UMultimedia} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "multimédia"
					local UMultimedia=1
				fi
				:
				;;
			"M" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					if [[ ${UCompletMaj} -eq 0 ]]; then
						InstallerPaquets "complet-maj"
						local UCompletMaj=1
					fi
					:
				fi
				:
				;;
			"n" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${UNormal} -eq 0 ]]; then
						if [[ ${UMAJDepots} -eq 0 ]]; then
							echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
							# Création du fichier temporaire pour y mettre les erreurs éventuelles
							if [[ ! -e "${TEMPORAIRE}" ]]; then
								touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
							fi
							if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
								sudo chown ${USER}: "${TEMPORAIRE}"															2>&0
							fi
							# Création du fichier journal
							if [[ ! -e "${JOURNALISATION}" ]]; then
								sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
							fi
							if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
								sudo chown ${USER}: "${JOURNALISATION}"															2>&0
							fi
							local UMAJDepots=1
							sudo apt-get update -qq -y														> '/dev/null'
							local CodeRetour=${?}
							TestSiErreur ${CodeRetour} "" "maj"
						fi
						InstallerPaquets "normal"
						local UNormal=1
					fi
					:
				fi
				:
				;;
			"p" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${USamsung} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "samsung"
					local USamsung=1
				fi
				:
				;;
			"r" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${URoccat} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "roccat"
					local URoccat=1
				fi
				:
				;;
			"s" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${USecurite} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "sécurité"
					local USecurite=1
				fi
				:
				;;
			"u" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UUtilitaires} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "utilitaires"
					local UUtilitaires=1
				fi
				:
				;;
			"v" )
				UAV=1		# Le marqueur d'utilisation de l'option aide/version passe à 1
				if [[ ${NBPARAMS} -gt 1  ]]; then
					if [[ ! -z ${OPTARG} ]]; then
						echo " ${ROUGE}${OPTARG} Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					else
						echo " ${ROUGE}Ne peut être utilisé avec un autre paramètre${DEFAUT}"
					fi
					echo
					exit 4
				else
					if [[ ${UVersion} -eq 0 ]]; then
						echo " ${CYAN}Paquets ${VERSION}${DEFAUT}"
						echo
						local UVersion=1
						exit 0
					fi
					:
				fi
				:
				;;
			"x" )
				if [[ ${UTitre} -ne 1 ]]; then
					AfficherTitre "${VERSION}"
					local UTitre=1
				fi
				if [[ ${UCompression} -eq 0 ]]; then
					if [[ ${UMAJDepots} -eq 0 ]]; then
						echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
						# Création du fichier temporaire pour y mettre les erreurs éventuelles
						if [[ ! -e "${TEMPORAIRE}" ]]; then
							touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${TEMPORAIRE}${DEFAUT}"
						fi
						if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
							sudo chown ${USER}: "${TEMPORAIRE}"																2>&0
						fi
						# Création du fichier journal
						if [[ ! -e "${JOURNALISATION}" ]]; then
							sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JOURNALISATION}${DEFAUT}"
						fi
						if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
							sudo chown ${USER}: "${JOURNALISATION}"																2>&0
						fi
						local UMAJDepots=1
						sudo apt-get update -qq -y															> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "" "maj"
					fi
					InstallerPaquets "compression"
					local UCompression=1
				fi
				:
				;;
			\? )
				if [[ ! -z ${OPTARG} ]]; then
					echo " ${ROUGE}Option ${OPTARG} invalide !${DEFAUT}"
					Usage
				else
					echo " ${ROUGE}Option invalide !${DEFAUT}"
					Usage
				fi
				exit 5
				;;
			: )
				if [[ ! -z ${OPTARG} ]]; then
					echo " ${ROUGE}Argument manquant au paramètre ${OPTARG}${DEFAUT}"
				else
					echo " ${ROUGE}Argument manquant au paramètre ${DEFAUT}"
				fi
				Usage
				exit 6
				;;
		esac
	done
	#shift $(( ${OPTIND} - 1 ))
}

# Test si erreur
function TestSiErreur(){
	# Variables locales
	local Objet="${2}"													# Paquet à installer, groupe ou autre...
	local Utilisateur"${USER}"												# Utilisateur
	local Type="$(echo ${3} | tr '[:upper:]' '[:lower:]')"									# Type (installation / désinstallation ?)
	local CodeRetour=${1}													# Code retourné par la fonction
	#
	# Création du fichier temporaire pour y mettre les erreurs éventuelles
	if [[ ! -e "${TEMPORAIRE}" ]]; then
		touch "${TEMPORAIRE}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du fichier ${JAUNE}${TEMPORAIRE}${DEFAUT}"
	fi
	if [[ -e "${TEMPORAIRE}" ]] && [[ ! -w "${TEMPORAIRE}" ]]; then
		sudo chown ${USER}: "${TEMPORAIRE}"																					2>&0
	fi
	# Création du fichier journal
	if [[ ! -e "${JOURNALISATION}" ]]; then
		sudo touch "${JOURNALISATION}" > '/dev/null' || echo " ${ROUGE}Échec lors de la tentative de création du journal ${JAUNE}${JOURNALISATION}${DEFAUT}"
	fi
	if [[ -e "${JOURNALISATION}" ]] && [[ ! -w "${JOURNALISATION}" ]]; then
		sudo chown ${USER}: "${JOURNALISATION}"																					2>&0
	fi
	if [[ -z "${Objet}" ]]; then
		local Objet="#INCONNU#"
	fi
	# Choix du tyme de message en fonction de l'évènement
	case "${Type}" in
		"kazam" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La configuration en stéréo pour ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						La configuration en stéréo pour ${Objet} a échoué [${CodeRetour}]"		>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						La configuration en stéréo pour ${Objet} a échoué [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Le fichier de configurations pour ${CYAN}${Objet} ${VERT}a bien été configuré pour la stéréo${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						${Objet} configuré pour la stéréo"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"ok" )
			echo " ${VERT}Paquet ${CYAN}${Objet} ${VERT}déjà installé${DEFAUT}"
			sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Paquet ${Objet} déjà installé"							>> "${JOURNALISATION}"	2>&0
			;;
		"copie" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La copie / restauration du fichier ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}{CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						La copie / restauration du fichier ${Objet} a échoué [${CodeRetour}]"		>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						La copie / restauration du fichier ${Objet} a échoué [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Copie / restauration du fichier ${CYAN}${Objet} ${VERT}terminée${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Copie / restauration du fichier ${Objet} terminée"			>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"mv" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Le déplacement / renommage du fichier vers ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Le déplacement /renommage du fichier vers ${Objet} a échoué [${CodeRetour}]"		>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Le déplacement / renommage du fichier vers ${Objet} a échoué [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"chmod" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec d'attribution des permissions sur ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${ROUGE}${PASGRAS})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'attribution des permissions sur ${Objet} [${CodeRetour}]"		>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'attribution des permissions sur ${Objet} [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"wget" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La tentative de téléchargement du paquet via lien ${JAUNE}${Objet}${ROUGE} a échoué (${MODEGRAS}${JAUNE}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec du téléchargemt du lien ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec du téléchargent du lien ${Objet} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Paquet téléchargé via lien ${CYAN}${Objet}${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Mise à jour des paquets effectuée"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"untar" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec de décompression du fichier ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la décompression du fichier ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de décompression du fichier ${Objet} [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Fichier ${CYAN}${Objet} ${VERT}décompressé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Fichier ${Objet} décompressé"						>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"clé" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}L'ajout de la clé ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						L'ajout de la clé ${Objet} a échoué [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						L'ajout de la clé ${Objet} a échoué [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Ajout de la clé ${CYAN}${Objet} ${VERT}terminé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Ajout de la clé ${Objet} terminé"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"ajout_dépôt" | "ajout_depot" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}L'ajout du dépôt ${JAUNE}${Objet}${ROUGE} a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de l'ajout du dépôt ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de l'ajout du dépôt ${Objet} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Ajout du dépôt ${CYAN}${Objet} ${VERT}terminé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Ajout du dépôt ${Objet} terminé"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"fix" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La tentative de réparation des dépendances pour ${JAUNE}${Objet} a échoué${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de réparation des dépendances pour ${Objet} [${CodeRetour}]"		>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de réparation des dépendances pour ${Objet} [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Réparation des dépendances pour ${CYAN}${Objet} ${VERT}terminée${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Réparation des dépendances pour ${Objet} terminée"			>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"ajout_source" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}L'ajout du dépôt source ${JAUNE}${Objet}${ROUGE} a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de l'ajout du dépôt source ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de l'ajout du dépôt source ${Objet} [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Ajout du dépôt source ${CYAN}${Objet} ${VERT}terminé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Ajout du dépôt source ${Objet} terminé"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"maj" | "mise à jour" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La mise à jour a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour des paquets [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour des paquets [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Mise à jour des paquets effectuée${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Mise à jour des paquets effectuée"					>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"maj_système" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La mise à jour du système a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour du système [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour du système [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Mise à jour du système terminée avec succès${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Mise à jour du système terminée avec succès"				>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"force" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La mise à jour pour forcer les dépendances manquantes a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour forcée des paquets [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la mise à jour forcée des paquets [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Mise à jour forcée des paquets effectuée${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Mise à jour forcée des paquets effectuée"				>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"désinstallé" )
				echo " ${MAGENTA}Paquet ${CYAN}${Objet} ${MAGENTA}déjà désinstallé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Paquet ${Objet} déjà désinstallé"					>> "${JOURNALISATION}"	2>&0
			;;
		"désinstallation" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}La désinstallation du paquet ${JAUNE}${Objet}${ROUGE} a rencontré une ou plusieurs erreurs (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la désinstallation du paquet ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la désinstallation du paquet ${Objet} [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${MAGENTA}Paquet ${CYAN}${Objet} ${MAGENTA}désinstallé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Désinstallation du paquet ${Objet} effectuée"				>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"lien" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec de la création du lien ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la création du lien ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de la création du lien ${Objet} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Lien symbolique ${CYAN}${Objet} ${VERT}créé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Lien ${Objet} créé"							>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"fichier" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Erreur lors de la tentative de création du fichier ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Erreur lors de la tentative de création du fichier ${Objet} [${CodeRetour}]"	>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						La configuration en stéréo pour ${Objet} a échoué [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Le fichier ${CYAN}${Objet} ${VERT}a bien été créé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Fichier ${Objet} créé"							>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"utilisateurs" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Utilisateur ${Utilisateur} non autorisé [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
		"groupe" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec d'attribution du groupe ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de mise à jour du groupe ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec lors de la mise à jour du groupe ${Groupe} [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Groupe ${CYAN}${Objet} ${VERT}mis à jour${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Groupe ${Objet} mis à jour"						>> "${JOURNALISATION}"	2>&0
			fi
			;;
		"création_service" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec de création du service ${JAUNE}{Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de création du service ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de création du service ${Groupe} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Service ${CYAN}${Objet} ${VERT}créé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Service ${Objet} créé"							>> "${JOURNALISATION}"	2>&0
			fi
			;;
		"démarrage_service" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec de démarrage du service ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de démarrage du service ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de démarrage du service ${Groupe} [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Le service ${CYAN}${Objet} ${VERT}a bien démarré${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Le service ${Objet} a bien démarré"					>> "${JOURNALISATION}"	2>&0
			fi
			;;
		"redémarrage_service" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec de redémarrage du service ${JAUNE}${Objet} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec de mise à jour du groupe ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec lors de la mise à jour du groupe ${Groupe} [${CodeRetour}]"	>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Service ${CYAN}${Objet} ${VERT}redémarré${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Service ${Objet} redémarré"						>> "${JOURNALISATION}"	2>&0
			fi
			;;
		"arrêt_service" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec d'arrêt du service ${JAUNE}${Objet}${Rouge} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'arrêt du service ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'arrêt du service ${Groupe} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${MAGENTA}Service ${CYAN}${Objet} ${MAGENTA}arrêté${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Service ${Objet} arrêté"						>> "${JOURNALISATION}"	2>&0
			fi
			;;
		"activation_module" )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}Échec d'activation du module ${JAUNE}${Objet}${ROUGE} (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'activation du module ${Objet} [${CodeRetour}]"				>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'activation du module ${Groupe} [${CodeRetour}]"			>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Module ${CYAN}${Objet} ${VERT}activé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Module ${Objet} activé"							>> "${JOURNALISATION}"	2>&0
			fi
			;;
		* )
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${ROUGE}L'installation du/des paquet(s) ${JAUNE}${Objet}${ROUGE} a échoué (${JAUNE}${MODEGRAS}${CodeRetour}${PASGRAS}${ROUGE})${DEFAUT}"
				echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'installation du/des paquet(s) ${Objet} [${CodeRetour}]"			>> "${TEMPORAIRE}"	2>&0
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Échec d'installation du/des paquet(s) ${Objet} [${CodeRetour}]"		>> "${JOURNALISATION}"	2>&0
			else
				echo " ${VERT}Paquet ${CYAN}${Objet}${VERT} installé${DEFAUT}"
				sudo echo "[$(date +%d-%m-%Y\ %H:%M:%S)]						Paquet ${Objet} installé"						>> "${JOURNALISATION}"	2>&0
			fi
			:
			;;
	esac
	:
}

# Pilotes graphiques
function PilotesGraphiques(){
	# Variables locales
	local Paquet=""														# Paquet à installer
	local CodeRetour=0													# Code retour
	#
	# Installation des pilotes NVidia
	local Paquet="nvidia-driver"					# Installation du pilote recommandé
	if [[ $(ubuntu-drivers devices | grep NVIDIA | awk '{print $3}' | tr '[:lower:]' '[:upper:]') == "NVIDIA" ]]; then
		if [[ $(dpkg -l | grep ${Paquet} | awk '{print $1}') != "ii" ]]; then
			echo " ${CYAN}Installation du pilote graphique NVidia [${VERT}${Paquet}${CYAN}]${DEFAUT}"
			sudo ubuntu-drivers autoinstall																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	# Installation des pilotes AMD (à tester)
	elif [[ $(lspci -vnn | grep VGA | grep AMD/ATI | awk '{print $10}' | sed "s/\[//g" | sed "s/\]//g" | tr '[:lower:]' '[:upper:]') == "AMD/ATI" ]]; then
		echo " ${CYAN}Installation du pilote graphique AMD${DEFAUT}"
		echo " ${JAUNE}Non testé pour le moment, à effectuer manuellement...${DEFAUT}"
	# Installation des pilotes Intel (à tester)
	elif [[ $(lspci -vnn | grep VGA | grep INTEL | awk '{print $10}' | sed "s/\[//g" | sed "s/\]//g" | tr '[:lower:]' '[:upper:]') == "AMD/ATI" ]]; then
		echo " ${CYAN}Installation du pilote graphique Intel${DEFAUT}"
		echo " ${JAUNE}Non testé pour le moment, à effectuer manuellement...${DEFAUT}"
	# Sinon, rien
	else
		echo " ${JAUNE}Aucune installation de pilote graphique ne sera effectuée${DEFAUT}"
	fi
	# Installation des outils pour cartes graphiques
	local Paquet="mesa-utils"					# Utilitaires pour tester la carte vidéo
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="mesa-utils-extra"					# Utilitaires pour tester la carte vidéo (extras)
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Pilotes Audio
#function PilotesAudio(){
#	# Variables locales
#	local Paquet=""														# Paquet à installer
#	local Depot=""														# Dépôt à rajouter
#	local CodeRetour=0													# Code retour
#	#
#	local Paquet="oem-audio-hda-daily-lts-vivid-dkms"		# Pilotes audio
#	local Depot="ppa:ubuntu-audio-dev/alsa-daily"			# Dépôt
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation des pilotes audio :${DEFAUT}"
#		sudo add-apt-repository -y ${Depot}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
#		echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
#		sudo apt-get update -qq -y																			> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "" "maj"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	fi
#	:
#}

# Pilotes Roccat
function PilotesRoccat(){
	# Variables locales
	local Paquet=""														# Paquet à installer
	local Depot=""														# Dépôt à rajouter
	local Lien=""														# Lien à créer
	local InitD=""														# Fichier de démarrage automatique
	local CodeRetour=0													# Code retour
	#
	local Paquet="roccat-tools"					# Pilotes pour claviers / souris Roccat
	local Depot="ppa:berfenger/roccat"				# Dépôt
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation des pilotes clavier / souris Roccat :${DEFAUT}"
		sudo add-apt-repository -y ${Depot}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
		echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
		sudo apt-get update -qq -y																			> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "" "maj"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
		if [[ ${CodeRetour} -eq 0 ]]; then
			# Débugguer Roccat-Tools (script Ripple FX introuvable)
			local Lien="/usr/share/roccat/ryos_effect_modules/ripple.lc"
			if [[ ! -e "${Lien}" ]]; then
				sudo ln -s "/usr/share/roccat/ryos_effect_modules/ripple.lua" "${Lien}"															2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Lien}" "lien"
			fi
			# Liens symboliques pour avoir roccateventhandler au démarrage
			local Lien="/etc/rc4.d/roccateventhandler"
			if [[ ! -L "${Lien}" ]] && [[ ! -e "${Lien}" ]]; then
				sudo ln -s "/etc/inid.d/roccateventhandler" "${Lien}"																	2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Lien}" "lien"
			fi
			local Lien="/etc/rc5.d/roccateventhandler"
			if [[ ! -L "${Lien}" ]] && [[ ! -e "${Lien}" ]]; then
				sudo ln -s "/etc/inid.d/roccateventhandler" "${Lien}"																	2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Lien}" "lien"
			fi
			local Lien="/etc/rc6.d/roccateventhandler"
			if [[ ! -L "${Lien}" ]] && [[ ! -e "${Lien}" ]]; then
				sudo ln -s "/etc/inid.d/roccateventhandler" "${Lien}"																	2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Lien}" "lien"
			fi
			local Lien="/etc/rcS.d/roccateventhandler"
			if [[ ! -L "${Lien}" ]] && [[ ! -e "${Lien}" ]]; then
				sudo ln -s "/etc/inid.d/roccateventhandler" "${Lien}"																	2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Lien}" "lien"
			fi
			AttributionGroupes "roccat"
			# Création du fichier de démarrage pour roccateventhandler
			local InitD="/etc/init.d/roccateventhandler"
			echo -e "#!/bin/sh\nroccateventhandler\n" | sudo tee "${InitD}"														> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${InitD}" "fichier"
			if [[ -e "${InitD}" ]]; then
				sudo chmod +x "${InitD}"																	> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${InitD}" "chmod"
			fi
		fi
	else
		echo " ${VERT}Les pilotes Roccat avaient déjà été installés${DEFAUT}"
	fi
	:
}

# Installation du pilote d'impression Samsung (action manuelle)
function PilotesImprimantesSamsung(){
	# Variables locales
	local Paquet="https://ftp.hp.com/pub/softlib/software13/printers/SS/SL-M4580FX/uld_V1.00.39_01.17.tar.gz"		# Paquet à télécharger
	local DosTar="/var/tmp"													# Répertoire temporaire
	local FicTar="$(echo $(basename ${Paquet}))"										# Nom du fichier temporaire
	local DestTar="${DosTar}/${FicTar}"											# Fichier temporaire de destination
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des pilotes de d'impression Samsung :${DEFAUT}"
	echo " ${JAUNE}Téléchargement du pilote ${CYAN}${FicTar}${JAUNE} en cours...${DEFAUT}"
	wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTar}"																	2>&0
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "${Paquet}" "wget"
	if [[ -e "${DestTar}" ]]; then
		tar -C "${DosTar}" -xf "${DestTar}"																					2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${FicTar}" "untar"
		if [[ -e "${DosTar}/uld/install.sh" ]]; then
			yes | sudo sh "${DosTar}/uld/install.sh"
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTar}" "uld"
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTar}" "uld"
		fi
	else
		local CodeRetour=127
		TestSiErreur ${CodeRetour} "${FicTar}" "uld"
	fi
	if [[ -e "${DestTar}" ]]; then
		rm "${DestTar}"																								2>&0
	fi
	if [[ -d "${DosTar}/uld" ]];  then
		sudo rm -rf "${DosTar}/uld"																						2>&0
	fi
	:
}

# Paquets de logiciels bureautique
function PaquetsBureautique(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des paquets de logiciels bureautiques :${DEFAUT}"
	if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
		local Paquet="kmymoney"					# Logiciel de gestion des comptes (mieu intégré à KDE / Plaslma)
	else
		local Paquet="gnucash"					# Logiciel de gestions des comptes
	fi
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libreoffice-base"					# Édition de bases de données
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libreoffice-l10n-fr"				# Pack de langue français pour OpenOffice
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libreoffice-pdfimport"				# Permet d'éditer les fichiers PDF
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	echo " ${CYAN}Désinstallation des applications bureautiques inutiles :${DEFAUT}"
	local Paquet="libreoffice-draw"					# Permet de faire des dessins
	if [[ $(dpkg -s ${Paquet} 2>  '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') == "ok" ]]; then
		echo " ${MAGENTA}Désinstallation du paquet ${CYAN}${Paquet}${MAGENTA} en cours...${DEFAUT}"
		sudo apt-get remove -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "désinstallation"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "désinstallé"
	fi
	local Paquet="libreoffice-math"					# Édition d'équations graphiques
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') == "ok" ]]; then
		echo " ${MAGENTA}Désinstallation du paquet ${CYAN}${Paquet}${MAGENTA} en cours...${DEFAUT}"
		sudo apt-get remove -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "désinstallation"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "désinstallé"
	fi
	:
}

# Paquets de compression et d'archivage
function PaquetsCompression(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local Paquet=""														# Paquet à installer
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des paquets de compression et archivage :${DEFAUT}"
	local Paquet="cabextract"					# Extraction d'archives CAB
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="p7zip-full"					# Extraction d'archives 7z
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="unace"						# Extraction d'archives ACE (unace-nonfree pour la version non libre)
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="unrar-free"					# Extraction d'archives RAR (unrar pour la version non libre)
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Paquets de développement
function PaquetsDeveloppement(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local DosTmp="/var/tmp"													# Répertoire temporaire
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des paquets de développements :${DEFAUT}"
	if [[ ${Type} != "légé" ]]; then
		# BlueGriffon
		local Paquet="http://bluegriffon.org/freshmeat/3.0.1/bluegriffon-3.0.1.Ubuntu16.04-x86_64.deb"
		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
		if [[ -e "${DestTmp}" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
				sudo apt --fix-broken install -y																&> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
			fi
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
		fi
		if [[ -e "${DestTmp}" ]]; then
			rm "${DestTmp}"																							2>&0
		fi
		:
	fi
	if [[ ${Type} == "tout" ]] ;then
	local Paquet="mono-devel"					# Plateforme d'exécution .NET
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="curl"						# Dépendance de Steam : bibliothèque de requêtes d'URL
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="git"						# Permet de conserver la version de ses scripts / codes sources
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="vim"						# Éditeur de textes en lignes de commandes très populaire avec coloration sytaxique
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Paquets de compilation (développement, noyau etc.)
function PaquetsCompilation(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des paquets de compilation :${DEFAUT}"
	if [[ ${Type} != "légé" ]]; then
		local Paquet="cmake"					# Compilateur C
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	if [[ ${Type} == "tout" ]]; then
		local Paquet="autoconf"					# Outils GNU autotools
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="automake"					# Outils GNU autotools
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="automake1.11"				# Outils GNU autotools
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="build-essential"					# Paquet contenant la base de la programmation !
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Paquets pour Internet et réseaux
function PaquetsInternet(){
# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des applications pour Internet :${DEFAUT}"
	if [[ "${Type}" != "légé" ]]; then
		local Paquet="chromium-browser"				# Chrome (version libre)
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="iperf"					# Test des performances du réseau
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="krfb"					# Partage du bureau à distance
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="linphone"					# Client SIP pour Linux
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="lynx"					# Un navigateur en mode console !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pavucontrol"				# Permet de configurer le micro sur Skype
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		# Skype
		local Paquet="https://repo.skype.com/latest/skypeforlinux-64.deb"
		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
		if [[ -e "${DestTmp}" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
				sudo apt --fix-broken install -y																&> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
			fi
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
		fi
		if [[ -e "${DestTmp}" ]]; then
			rm "${DestTmp}"																							2>&0
		fi
#		local Paquet="skype"					# Visioconférences et messagerie instantannée
#		if [[ $(snap list | grep ${Paquet} | awk '{print $1}' 2>&0 | tr '[:upper:]' '[:lower:]') != "${Paquet}" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			snap install ${Paquet} --classic																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="wakeonlan"				# Wake On Lan
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
	fi
	if [[ "${Type}" == "tout" ]]; then
		local Paquet="pidgin"					# Messagerie instantannée
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-gmchess"				# Jeu d'échc sur Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-hotkeys"				# Raccourcis Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-lastfm"				# Last FM sur Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-musictracker"			# Affiche la musique en écoute sur Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-skype"				# Ajout de Skype sur Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pidgin-themes"				# Possibilité d'appliquer des thèmes sur Pidgin
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="filezilla"					# Client FTP graphique
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="nfs-common"					# Prise en charge du réseau NFS
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="thunderbird"					# Client de messagerie
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="thunderbird-locale-fr"				# Permet de passer Thunderbird en français
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Jeux-vidéo sous Linux
function PaquetsJeux(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local DosTmp="/var/tmp"													# Répertoire temporaire
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local Cle=""														# Clé publique du dépôt
	local Depot=""														# Dépôt à rajouter
	local CodeRetour=0													# Code retour
	#
	if [[ "${Type}" != "légé" ]]; then
		echo " ${CYAN}Installation des jeux :${DEFAUT}"
#		local Paquet="alien-arena"				# Un Quake-like dans la peau d'aliens !
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="chromium-bsu"				# Un jeu de vaisseau arcade
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		# Gens/GS (non compatible 64 bit)
#		local Paquet="https://retrocdn.net/images/e/e9/Gens_2.16.8-r7orig_amd64.deb"
#		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
#		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
#		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
#		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
#		if [[ ${CodeRetour} -eq 0 ]]; then
#			echo " ${JAUNE}Ajout de la compatibilité des applications 32 bits en cours...${DEFAUT}"
#		fi
#		local Paquet="multiarch-support"			# Prise en charge des applications 32 bits
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
#		local Paquet="https://retrocdn.net/images/e/e9/Gens_2.16.8-r7orig_amd64.deb"
#		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
#		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
#		if [[ -e "${DestTmp}" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
#			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
#			if [[ ${CodeRetour} -ne 0 ]]; then
#				echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
#				sudo apt --fix-broken install -y																&> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
#			fi
#		else
#			local CodeRetour=127
#			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
#		fi
#		if [[ -e "${DestTmp}" ]]; then
#			rm "${DestTmp}"																							2>&0
#		fi
		local Paquet="ioquake3"					# Quake 3 Arena amélioré !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="mupen64plus-qt"				# Un émulateur Nintendo 64
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="openarena"				# La renaîssance de Quake 3 Arena !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="open-invaders"				# Space Invaders sous Linux !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="pcsxr"					# Émulateur PlayStation
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="pcsx2"					# Émulateur PlayStation 2
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="pokerth"					# Poker sur Linux !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="vbaexpress"				# Émulateur GameBoy Advanced
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="zsnes"					# Émulateur Super Nintendo (remplacé par Snes9x ?)
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
#		:
	fi
	if [[ "${Type}" == "tout" ]]; then
#		local Paquet="alien-arena-server"			# Serveur Alien Arena
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="armagetronad-dedicated"			# Possibilité de créer des serveurs Armagetron
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="ioquake3-server"				# Possibilité de créer des serveurs Quake 3 Arena
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="openarena-server"				# Possibilité de créer des serveurs Open Arena
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="quake3-server"				# Possibilité de créer des serveurs Quake 3 Arena
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="warmux-servers"				# Possibilité de créer des serveurs Warmux
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="armagetronad"					# Tron (jeu de motos futuristes)
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="extremetuxracer"					# Un jeu type Mario Kart sous Linux !
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="pingus"						# Lemmings version Linux !
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="steam-launcher"					# Steam (la librairie libdbusmenu-gtk4:i386 n'est plus disponible)
	local Cle="B05498B7"						# Clé publique du dépôt
	local Depot="http://repo.steampowered.com/steam/"		# Dépôt
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		echo " ${JAUNE}Ajout de la clé publique ${CYAN}${Cle}${JAUNE} pour le dépôt ${CYAN}${Depot}${JAUNE} en cours...${DEFAUT}"
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${Cle}													&> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Cle}" "clé"
		if [[ ! -e "/etc/apt/sources.list.d/$(echo ${Paquet} | sed 's/-launcher//g').list" ]] ||\
			[[ ! $(cat "/etc/apt/sources.list.d/$(echo ${Paquet} | sed 's/-launcher//g').list" &> '/dev/null') =~ deb\ \[arch=amd64,i386\]\ ${Depot}\ precise\ steam ]]; then
			echo "deb [arch=amd64,i386] ${Depot} precise steam" |  sudo tee "/etc/apt/sources.list.d/$(echo ${Paquet} | sed 's/-launcher//g').list"					> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			if [[ ${CodeRetour} -eq 0 ]] &&\
				[[ ! $(cat "/etc/apt/sources.list.d/$(echo ${Paquet} | sed 's/-launcher//g').list" &> '/dev/null') =~ deb-src\ \[arch=amd64,i386\]\ ${Depot}\ precise\ steam ]]; then
				echo "deb-src [arch=amd64,i386] ${Depot} precise steam" | sudo tee -a "/etc/apt/sources.list.d/$(echo ${Paquet} | sed 's/-launcher//g').list"			> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Depot}" "ajout_source"
			fi
			:
		fi
		echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
		sudo apt-get update -qq -y																			> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "" "maj"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
		if [[ ${CodeRetour} -eq 0 ]]; then
			echo " ${JAUNE}Installation des dépendances pour Steam en cours...${DEFAUT}"
#			local Paquet="libc6:i386"			# Dépendance de Steam
#			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}"
#				if [[ ${CodeRetour} -ne 0 ]]; then
#					echo " ${JAUNE}Suite à l'échec de l'installation de ce paquet, Steam risque de ne pas fonctionner correctement${DEFAUT}"
#				fi
#			else
#				local CodeRetour=0
#				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#			fi
#			local Paquet="libgl1-mesa-dri:i386"		# Dépendance de Steam
#			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}"
#				if [[ ${CodeRetour} -ne 0 ]]; then
#					echo " ${JAUNE}Suite à l'échec de l'installation de ce paquet, Steam risque de ne pas fonctionner correctement${DEFAUT}"
#				fi
#			else
#				local CodeRetour=0
#				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#			fi
#			local Paquet="libgl1-mesa-glx:i386"		# Dépendance de Steam
#			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}"
#				if [[ ${CodeRetour} -ne 0 ]]; then
#					echo " ${JAUNE}Suite à l'échec de l'installation de ce paquet, Steam risque de ne pas fonctionner correctement${DEFAUT}"
#				fi
#			else
#				local CodeRetour=0
#				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#			fi
			local Paquet="xterm"				# Console de base, dépendance de Steam et de TeamSpeak
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					echo " ${JAUNE}Suite à l'échec de l'installation de ce paquet, Steam risque de ne pas fonctionner correctement${DEFAUT}"
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			echo " ${JAUNE}Fin d'installation des dépendances de Steam${DEFAUT}"
		fi
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="warmux"						# Un jeu de type "Worm" en plus marrant !
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	echo " ${CYAN}Installation des logiciels de communication pour joueurs :${DEFAUT}"
	# Discord
	local Paquet="https://discordapp.com/api/download?platform=linux&format=deb"
	local FicTmp="$(echo ${Paquet} | awk '{print substr($0,9,7)}')"	# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}.deb"				# Fichier temporaire de destination
	echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
	wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																	2>&0
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "${Paquet}" "wget"
	if [[ -e "${DestTmp}" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
		sudo dpkg -i "${DestTmp}"																			&> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
		if [[ ${CodeRetour} -ne 0 ]]; then
			echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
			sudo apt --fix-broken install -y																	&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
		fi
	else
		local CodeRetour=127
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
	fi
	if [[ -e "${DestTmp}" ]]; then
		rm "${DestTmp}"																								2>&0
	fi
	if [[ ${Type} == "complet" ]]; then
		local Paquet="mumble"					# Logiciel de communication pour les joueurs !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		if [[ ! -d "/opt/TeamSpeak3-Client-linux_amd64" ]]; then
#			if [[ $(lscpu | grep -i "Architecture" | awk '{print $2}' | tr '[:upper:]' '[:lower:]') == "x86_64" ]]; then
#				# TeamSpeak (64 bit)
#				local Paquet="https://files.teamspeak-services.com/releases/client/3.2.5/TeamSpeak3-Client-linux_amd64-3.2.5.run"
#				local FicTmp="$(echo $(basename ${Paquet}))"							# Nom du fichier temporaire
#				local DestTmp="${DosTmp}/${FicTmp}"								# Fichier temporaire de destination
#				echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
#				sudo wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"														2>&0
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}" "wget"
#				if [[ -e "${DestTmp}" ]]; then
#					echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
#					sudo chmod +x "${DestTmp}"																			2>&0
#					local CodeRetour=${?}
#					TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
#					if [[ ${CodeRetour} -eq 0 ]]; then
#						sudo yes y | "${DestTmp}"															> '/dev/null'
#						local CodeRetour=${?}
#						TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
#					fi
#				else
#					local CodeRetour=127
#					TestSiErreur ${CodeRetour} "${FicTmp}" "absent"
#				fi
#				if [[ -e "${DestTmp}" ]]; then
#					sudo rm "${DestTmp}"																				2>&0
#				fi
#				:
#			else
#				# TeamSpeak (32 bit)
#				local Paquet="https://files.teamspeak-services.com/releases/client/3.2.5/TeamSpeak3-Client-linux_x86-3.2.5.run"
#				local FicTmp="$(echo $(basename ${Paquet}))"							# Nom du fichier temporaire
#				local DestTmp="${DosTmp}/${FicTmp}"								# Fichier temporaire de destination
#				echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
#				sudo wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"														2>&0
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}" "wget"
#				if [[ -e "${DestTmp}" ]]; then
#					echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
#					sudo chmod +x "${DestTmp}"																			2>&0
#					local CodeRetour=${?}
#					TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
#					if [[ ${CodeRetour} -eq 0 ]]; then
#						sudo yes y | "${DestTmp}"															> '/dev/null'
#						local CodeRetour=${?}
#						TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
#					fi
#				else
#					local CodeRetour=127
#					TestSiErreur ${CodeRetour} "${FicTmp}" "absent"
#				fi
#				:
#			fi
#			:
#		fi
		local Paquet="nextcloud-client"				# Client Nexcloud pour Linux
		:
	fi
	:
}

# Paquets multimédia
function PaquetsMultimedia(){
# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local DosTmp="/var/tmp"													# Répertoire temporaire
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local Dest=""														# Destination
	local Fic=""														# Fichier de destination
	local Cle=""														# Clé publique du dépôt
	local Depot=""														# Dépôt à rajouter
	local GimpLocal=""													# Dossier des paramètres personnels de Gimp
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des paquets multimédias :${DEFAUT}"
	if [[ "${Type}" != "légé" ]]; then
		local Paquet="audacity"					# Edition de pistes audio
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="easytag"					# Un taggueur pour fichiers audio
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="icedax"					# Conversion CDA
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="inkscape"					# Déssins vectoriels
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
			local Paquet="kdenlive"				# Éditeur vidéo
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		else
			local Paquet="pitivi"				# Éditeur vidéo
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		local Paquet="kid3-cli"					# Un taggueur pour fichiers audio (en lignes de commandes)
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="kid3-core"				# Un taggueur pour fichiers audio
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		# Molotov.tv
		if [[ ! -d "/opt/molotov.AppImage" ]]; then
			local Paquet="http://desktop-auto-upgrade.molotov.tv/linux/4.0.0/molotov.AppImage"
			local Fic="$(echo $(basename ${Paquet}))"								# Fichier de destination
			local Dest="/opt/${Fic}"										# Destination
			echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
			sudo wget -q "${Paquet}" --show-progress --progress=bar:force -O "${Dest}"																2>&0
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}" "wget"
			if [[ -e "${Dest}" ]]; then
				sudo chmod +x "${Dest}"																						2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Fic}" "chmod"
				if [[ ${CodeRetour} -eq 0 ]]; then
					echo " ${JAUNE}Pensez à faire un ${CYAN}./${Dest}${JAUNE} pour effectuer le premier lancement et l'intégration du logiciel ${CYAN}${Fic}${DEFAUT}"
				fi
			else
				local CodeRetour=127
				TestSiErreur ${CodeRetour} "${Fic}" "absent"
			fi
		fi
#		local Paquet="moodbar"					# Humeurs pour Amarok
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="obs-studio"				# Permet de faire du streaming vidéo sur Twitch et YouTube
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="soundkonverter"				# Conversion audio
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="spotify"					# Lecteur multimédia en ligne
		local Cle="931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90"	# Clé publique du dépôt
		local Depot="http://repository.spotify.com"		# Dépôt
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			echo " ${JAUNE}Ajout de la clé publique ${CYAN}${Cle}${JAUNE} pour le dépôt ${CYAN}${Depot}${JAUNE} en cours...${DEFAUT}"
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${Cle}															2>&0
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Cle}" "clé"
			if [[ ! -e "/etc/apt/sources.list.d/${Paquet}.list" ]] || [[ ! $(cat "/etc/apt/sources.list.d/${Paquet}.list" 2>'/dev/null') =~ deb\ ${Depot}\ stable\ non-free ]]; then
				echo "deb ${Depot} stable non-free" | sudo tee "/etc/apt/sources.list.d/${Paquet}.list"										> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			fi
			echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
			sudo apt-get update -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="spotify"					# Lecteur multimédia en ligne
#		if [[ $(snap list | grep ${Paquet} | awk '{print $1}' 2>&0 | tr '[:upper:]' '[:lower:]') != "${Paquet}" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			snap install ${Paquet}																			> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="streamripper"				# Enregistrement de flux audio (kstreamripper non disponible)
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	if [[ "${Type}" == "tout" ]]; then
		local Paquet="abcde"					# Encodeur CD sous terminal
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="blender"					# Suite logicielle pour création 3D, la référence !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="desktop-file-utils"			# Utile pour l'installation de Mobile Media Converter
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
#			local Paquet="kmplayer"				# Lecteur multimédia pour KDE
#		else
#			local Paquet="mplayer"				# Un super lecteur multimédia !
#		fi
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
	local Paquet="timidity"						# Support MIDI
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
#		local Paquet="xine-plugin"				# Permet de voir des vidéos avec un navigateur
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		:
	fi
#	local Paquet="djmount"						# Client UPnP
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	else
#		local CodeRetour=0
#		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#	fi
#	local Paquet="faac"						# Codec AAC
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	else
#		local CodeRetour=0
#		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#	fi
	local Paquet="faad"						# Codec M4A
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="flac"						# Codec FLAC
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
#	local Paquet="gstreamer0.10-ffmpeg"				# Permet de lire les vidéos MP4
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	else
#		local CodeRetour=0
#		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#	fi
	local Paquet="gstreamer1.0-plugins-bad-faad"			#
	if [[ $(dpkg -s ${Paquet} 2>  '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gstreamer1.0-plugins-ugly"			# Permet de lire les fichiers MP3
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gstreamer1.0-libav"				# 
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="handbrake"					# Encodage / décodage vidéo
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="handbrake-cli"					# Encodage / décodage vidéo en lignes de commandes
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
		local Paquet="kipi-plugins"				# Modules complémentaires pour Gwenview
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="gimp"						# Edition d'images
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gimp-data-extras"					# Plugins pour Gimp
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gimp-plugin-registry"				# 
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gimp-ufraw"					# Prise en compte du format RAW pour Gimp
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	# Copie du plugin flèches pour Gimp
	if [[ $(ls -a "${HOME}" | grep .gimp | wc -l) -eq 1 ]]; then
		local Paquet="http://lehollandaisvolant.net/tout/dl/gimp-plugin/arrow-fr.scm"
		local GimpLocal="$(ls -a ${HOME} | grep .gimp)"
		echo " ${JAUNE}Téléchargement du plugin ${CYAN}$(basename ${Paquet})${JAUNE} pour Gimp en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${HOME}/${GimpLocal}/scripts/$(basename ${Paquet})"											2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
	elif [[ $(ls -a "${HOME}" | grep .gimp | wc -l) -gt 1 ]]; then
		echo " ${MAGENTA}$(ls -a ${HOME} | grep .gimp | wc -l)${JAUNE} répertoires .gimp ont été détectés.${DEFAUT}"
		echo " ${JAUNE}Prévoir l'installation manuelle du plugin ${CYAN}$(basename ${Paquet})${JAUNE} pour Gimp${DEFAUT}"
	else
		echo " ${JAUNE}Prévoir l'installation manuelle du plugin ${JAUNE}$(basename ${Paquet})${JAUNE} pour Gimp${DEFAUT}"
	fi
	local Paquet="lame"						# Codec LAME (s'utilise avec sox pour la conversion OGG)
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libavcodec-extra"					# Permet de lire d'autre formats multimédias
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libdvdnav4"					# Lecture des DVD avec menus
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libgstreamer-plugins-bad1.0-0"			# 
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libk3b7-extracodecs"				# Des plugins additionnels pour K3B
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	
	if [[ $(lscpu | grep -i "Architecture" | awk '{print $2}' | tr '[:upper:]' '[:lower:]') == "x86_32" ]]; then
		# Mobile Media Converter (non compatible 64 bit)
		local Paquet="https://www.miksoft.net/products/mmc_1.8.5_staticffmpeg.deb"
		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
		if [[ -e "${DestTmp}" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
				sudo apt --fix-broken install -y																&> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
			fi
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
		fi
		if [[ -e "${DestTmp}" ]]; then
			rm "${DestTmp}"																							2>&0
		fi
	fi
	local Paquet="regionset"					# Lecture des DVD multi-régions
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="sox"						# Conversion OGG vers MP3
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="speex"						# Codec Speex
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
#	local Paquet="transcode"					# Encodage de vidéos RAW
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	else
#		local CodeRetour=0
#		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#	fi
	local Paquet="vorbis-tools"					# Codec OGG Vorbis
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="wavpack"						# Codec WavePack
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Paquets serveurs
function PaquetsServeurs(){
# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local Paquet=""														# Paquet à installer
	local Service=""													# Service
	local eLAMP=0														# Passe à 1 si erreur d'installation ou désactivation LAMP
	local eLEMP=0														# Passe à 1 si erreur d'installation ou désactivation LEMP
	local CodeRetour=0													# Code retour
	#
	if [[ "${Type}" == "tout" ]]; then
		local Paquet="dhcp3-server"				# Attribue dynamiquement les adresses IP
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="ipxe"					# Protocole IPX
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		# Installation du serveur Web + PHP
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="apache2"				# Serveur Web
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="apache2-doc"			# Documentations apache2
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="mysql-server"			# Serveur MySQL
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="php7.2"				# PHP 7.2
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="libapache2-mod-php7.2"		# Module PHP pour Apache
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="php7.2-mysql"			# Module MySQL pour PHP
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			local Paquet="phpmyadmin"			# Administration SQL via interface Web
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
				if [[ ${CodeRetour} -ne 0 ]]; then
					local eLAMP=1
					:
				fi
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		if [[ ${eLAMP} -eq 0 ]]; then
			# Mettre les logs Apache en RAM
			local Service="apache2-tmpfs"			# Execution du script de mise en cache avant le lancement d'Apache
			sudo update-rc.d ${Service} defaults 90 10
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "création_service"
			local Service="rewrite"				# Activation de module "rewrite" pour Apache
			sudo a2enmod ${Service}
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "activation_module"
			local Service="proxy"				# Activation de module "proxy" pour Apache
			sudo a2enmod ${Service}
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "activation_module"
			local Service="proxy_html"			# Activation de module "proxy_html" pour Apache
			sudo a2enmod ${Service}
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "activation_module"
			local Service="headers"				# Activation de module "headers" pour Apache
			sudo a2enmod ${Service}
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "activation_module"
			local Service="deflate"				# Activer la compression
			sudo a2enmod ${Service}
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "activation_module"
			local Service="apache2"				# Relance service Apache2
			sudo ${Service} restart
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Service}" "redémarrage_service"
#			# Mettre MySQL en RAM
#			local Service="mysql"				# Arrêt service MySQL
#			sudo service ${Service} stop
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Service}" "arrêt_service"
#			local Service="mysql-tmpfs"			# Execution du script de mise en cache avant le lancement de MySQL
#			sudo update-rc.d ${Service} defaults 18 22
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Service}" "activation_service"
#			local Service="mysql"				# Démarrage service MySQL
#			sudo service ${Service} start
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Service}" "démarrage_service"
			# Première base de donnée
			if [[ -e "./mysqlconf.sh" ]]; then
				bash "./mysqlconf.sh"
			fi
			:
		fi
		local Paquet="proftpd-basic"				# Serveur FTP
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="ssh"					# Installation du serveur SSH
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="samba"						# Partage de fichiers en réseau
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
}

# Paquets antivirus et pare-feu
function PaquetsSecurite(){
# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local Paquet=""														# Paquet à installer
	local CodeRetour=0													# Code retour
	#
	if [[ "${Type}" == "tout" ]]; then
		local Paquet="aircrack-ng"				# Piratage Wi-Fi
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="clamav-daemon"				# Démon de Clamav, trop lent à mon goût...
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="inotify-tools"				# Librairie pour scan automatique
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="libnotify-bin"				# Librairie pour scan automatique
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="john"					# Brute Force
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="wireshark"				# Sniffeur réseau
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	echo " ${CYAN}Installation des solutions de sécurité :${DEFAUT}"
	local Paquet="clamav"						# Antivirus
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="clamtk"						# Interface graphique pour Clamav
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gufw"						# Un pare-feux graphique !
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
		:
}

# Paquets utilitaires
function PaquetsUtilitaires(){
# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local DosTmp="/var/tmp"													# Répertoire temporaire
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local ImageCD=""													# Fichier ISO
	local Cle=""														# Clé publique du dépôt
	local Depot=""														# Dépôt à rajouter
	local VBoxInstalle=0													# Passe à 1 si le paquet de VirtualBox (ou un plugin) s'est bien installé
	local VBoxVersion=""													# Variable pour la version de Virtual Box
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installation des utilitaires :${DEFAUT}"
	if [[ "${Type}" != "légé" ]]; then
		if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
			local Paquet="k3b-extrathemes"			# Thèmes supplémentaires pour K3b
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			local Paquet="kchmviewer"			# Lecture des fichiers d'aide Windows
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			local Paquet="kgpg"				# Utilisation graphique du GnuPGP !
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			local Paquet="krdc"				# VNC pour KDE
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			local Paquet="yakuake"				# Console fun pour KDE
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		local Paquet="acetoneiso"				# L'utilitaire le plus géant des images CD !
		if [[ $(dpkg -s ${Paquet} 2>'/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="kazam"					# Capture vidéo du bureau
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
			local Fichier="/usr/lib/python3/dist-packages/kazam/backend/gstreamer.py"
			if [[ -e "${Fichier}" ]]; then
				echo " ${JAUNE}Mise en place de la configuration en stéréo de Kazam...${DEFAUT}"
				sudo sed -i "/self.aud\(\|2\)_caps/s/audio\/x-raw/audio\/x-raw,channels=2/g" "${Fichier}"									> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}" "${Paquet}"
			fi
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="fuseiso"					# Montage d'images ISO
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		if [[ $(lscpu | grep -i "Architecture" | awk '{print $2}' | tr '[:upper:]' '[:lower:]') == "x86_64" ]]; then
			if [[ ! -d "/opt/genymotion" ]]; then
				# Genymotion
				local Paquet="https://dl.genymotion.com/releases/genymotion-3.0.2/genymotion-3.0.2-linux_x64.bin"
				local FicTmp="$(echo $(basename ${Paquet}))"							# Nom du fichier temporaire
				local DestTmp="${DosTmp}/${FicTmp}"								# Fichier temporaire de destination
				echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
				sudo wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"														2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}" "wget"
				if [[ -e "${DestTmp}" ]]; then
					echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
					sudo chmod +x "${DestTmp}"																			2>&0
					local CodeRetour=${?}
					TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
					if [[ ${CodeRetour} -eq 0 ]]; then
						yes | sudo "${DestTmp}"																> '/dev/null'
						local CodeRetour=${?}
						TestSiErreur ${CodeRetour} "${FicTmp}" "chmod"
					fi
				else
					local CodeRetour=127
					TestSiErreur ${CodeRetour} "${FicTmp}" "absent"
				fi
				if [[ -e "${DestTmp}" ]]; then
					sudo rm "${DestTmp}"																				2>&0
				fi
				:
			fi
			:
		fi
		local Paquet="keepassxc"				# Gestionnaire de mots de passe
		local Cle="D89C66D0E31FEA2874EBD20561922AB60068FCD6"	# Clé publique du dépôt
		local Depot="ppa:phoerious/keepassxc"			# Dépôt
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			echo " ${JAUNE}Ajout de la clé publique ${CYAN}${Cle}${JAUNE} pour le dépôt ${CYAN}${Depot}${JAUNE} en cours...${DEFAUT}"
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${Cle}															2>&0
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Cle}" "clé"
			sudo add-apt-repository -y ${Depot}																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
			sudo apt-get update -qq -y																			> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
			sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		fi
#		local Paquet="multisystem"				# Permet de créer des clés USB démarrables avec plusieurs systèmes
#		local Cle="http://liveusb.info/multisystem/depot/multisystem.asc"						# Clé publique du dépôt
#		local Depot="http://liveusb.info/multisystem/depot"	# Dépôt
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			echo " ${JAUNE}Ajout de la clé publique ${CYAN}${Cle}${JAUNE} pour le dépôt ${CYAN}${Depot}${JAUNE} en cours...${DEFAUT}"
#			sudo wget -q -O- ${Cle} | sudo apt-key add -																			2>&0
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Cle}" "clé"
#			echo "deb http://liveusb.info/multisystem/depot all main" |  sudo tee "/etc/apt/sources.list.d/${Paquet}.list"								> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
#			if [[ ${CodeRetour} -eq 0 ]]; then
#				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}"
#			fi
#			if [[ -e "multisystem.asc" ]]; then
#				sudo rm "multisystem.asc"																	> '/dev/null'
#			fi
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="nextcloud-client"				# Client Nexcloud pour Linux
		local Depot="ppa:nextcloud-devs/client"			# Dépôt
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo add-apt-repository -y ${Depot}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
			sudo apt-get update -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
			if [[ ${CodeRetour} -eq 0 ]]; then
				if [[ $(wich caja 2> '/dev/null') -eq 0 ]]; then
					echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
					local Paquet="nextcloud-client-nemo"
					sudo apt-get install -qq -y ${Paquet}															> '/dev/null'
					local CodeRetour=${?}
					TestSiErreur ${CodeRetour} "${Paquet}"
				elif  [[ $(wich dolphin 2> '/dev/null') -eq 0 ]]; then
					echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
					local Paquet="nextcloud-client-dolphin"
					sudo apt-get install -qq -y ${Paquet}															> '/dev/null'
					local CodeRetour=${?}
					TestSiErreur ${CodeRetour} "${Paquet}"
				elif  [[ $(wich nautilus 2> '/dev/null') -eq 0 ]]; then
					echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
					local Paquet="nextcloud-client-nautilus"
					sudo apt-get install -qq -y ${Paquet}															> '/dev/null'
					local CodeRetour=${?}
					TestSiErreur ${CodeRetour} "${Paquet}"
				elif  [[ $(wich nemo 2> '/dev/null') -eq 0 ]]; then
					echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
					local Paquet="nextcloud-client-nemo"
					sudo apt-get install -qq -y ${Paquet}															> '/dev/null'
					local CodeRetour=${?}
					TestSiErreur ${CodeRetour} "${Paquet}"
				else
					echo " ${JAUNE}Gestionnaire de fichiers non reconnu : nextcloud est installé mais sans intégration au gestionnaire de fichiers${DEFAUT}"
				fi
				:
			fi
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="recordmydesktop				# Capture vidéo du bureau
#		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#			if [[ ${CodeRetour} -eq 0 ]]; then
#				local Paquet="gtk-recordmydesktop"	# Interface graphique p our RecordMyDesktop
#				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
#				local CodeRetour=${?}
#				TestSiErreur ${CodeRetour} "${Paquet}"
#			else
#				local CodeRetour=0
#				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#			fi
#			:
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="wine"					# Émulateur Windows
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="wine64"					# Prise en charge 64 bits pour Wine
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="xdotool"					# Permet d'automatiser des clics souris et entrées clavier !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="xterm"					# Console de base
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="virtualbox-6.0"				# Émulateur PC/Mac
		if [[ $(lsb_release -r | awk '{print $2}' | awk '{print substr($0,1,2)}') -gt 16 ]]; then
			local Cle="http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc"			# Clé publique du dépôt (depuis version 16.04)
		else
			local Cle="http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc"				# Clé publique du dépôt (avant version 16.04)
		fi
		local Depot="http://download.virtualbox.org/virtualbox/debian"							# Dépôt
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			echo " ${JAUNE}Ajout de la clé publique ${CYAN}${Cle}${JAUNE} pour le dépôt ${CYAN}${Depot}${JAUNE} en cours...${DEFAUT}"
			sudo wget -q -O- ${Cle} | sudo apt-key add -																&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Cle}" "clé"
			if [[ $(lsb_release -r | awk '{print $2}' | awk '{print substr($0,1,2)}') -lt 18 ]]; then
				echo "deb ${Depot} $(lsb_release -c | awk '{print $2}') contrib" |  sudo tee "/etc/apt/sources.list.d/${Paquet}.list"						> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			elif [[ $(lsb_release -r | awk '{print $2}' | awk '{print substr($0,1,2)}') -eq 18 ]] && [[ -z $(lsb_release -r | awk '{print $2}' | awk '{print substr($0,1,7)}') ]]; then
				echo "deb ${Depot} $(lsb_release -c | awk '{print $2}') contrib" |  sudo tee "/etc/apt/sources.list.d/${Paquet}.list"						> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			else
				echo "deb [arch=amd64,i386] ${Depot} $(lsb_release -c | awk '{print $2}') contrib" |  sudo tee "/etc/apt/sources.list.d/${Paquet}.list"				> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
			fi
			echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
			sudo apt-get update -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
			if [[ ${CodeRetour} -eq 0 ]]; then
				AttributionGroupes "virtualbox"
				# Installation des outils pour les machines virtuelles
				local VBoxVersion="$(vboxmanage --version)"
				local ImageCD="http://download.virtualbox.org/virtualbox/$(echo ${VBoxVersion} | awk '{print substr($0,1,5)}')/VBoxGuestAdditions_$(echo ${VBoxVersion} | awk '{print substr($0,1,5)}').iso"
			  	sudo wget "${ImageCD}" --show-progress --progress=bar:force -O "/usr/share/virtualbox/VBoxGuestAdditions.iso"										2>&0
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${ImageCD}" "wget"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	if [[ "${Type}" == "complet" ]]; then
		if [[ ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
			local Paquet="kdocker"				# Réduire les applications dans la barre des tâches
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			local Paquet="kdenetwork-dbg"			# Librairie de débuguage
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		local Paquet="alien"					# Installation des parquets RPM
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="android-tools-adb"			# Outils pour Android
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="bluez-btsco"				# Prise en charge des casques stéréo Bluetooth
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="bluez-pcmcia-support"			# Prise en charge des cartes PCMCIA Bluetooth
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local  Paquet="flashrom"				# Flasher le BIOS depuis Linux !
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="libcv2.3"					# Librairie de reconnaissance faciale
#		if [[ $(dpkg -s ${Paquet} 2>'/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
#		local Paquet="libcv-dev"				# Librairie de reconnaissance faciale
#		if [[ $(dpkg -s ${Paquet} 2>'/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="obexftp"					# Protocole de transfert de fichiers Bluetooth (voire Irda)
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="pam-face-authentication"			# Reconnaissance faciale
#		if [[ $(dpkg -s ${Paquet} 2>'/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="python-gpgme"				# Pour Dropbox...
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="grub-customizer"				# Permet de personnaliser Grub
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="gsfonts-x11"				# Polices Ghostscript sous x11
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
#		local Paquet="libqt4-dbg"				# Librairie de débuguage
#		if [[ $(dpkg -s ${Paquet} 2>'/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "${Paquet}"
#		else
#			local CodeRetour=0
#			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#		fi
		local Paquet="lsb"					# Support Linux Standard Base 3.2
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
			:
	fi
	if [[ ! ${DESKTOP_SESSION} =~ plasma|kde|kde-plasma ]]; then
		local Paquet="numlockx"					# Activation du pavé numérique
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		local Paquet="unetbootin"				# Utilitaire pour créer des clés USB démarrables au boot
		local Depot="ppa:gezakovacs/ppa"
		sudo add-apt-repository -y ${Depot}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Depot}" "ajout_dépôt"
		echo " ${JAUNE}Mise à jour en cours...${DEFAUT}"
		sudo apt-get update -qq -y																			> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "" "maj"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
		if [[ ${CodeRetour} -eq 0 ]]; then
			if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
				echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
				sudo apt-get install -qq -y ${Paquet}																> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${Paquet}"
			else
				local CodeRetour=0
				TestSiErreur ${CodeRetour} "${Paquet}" "ok"
			fi
			:
		fi
		:
	else
		local Paquet="usb-creator-kde"				# Utilitaire pour créer des clés USB démarrrables au boot
		if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
			sudo apt-get install -qq -y ${Paquet}																	> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${Paquet}"
		else
			local CodeRetour=0
			TestSiErreur ${CodeRetour} "${Paquet}" "ok"
		fi
		:
	fi
	local Paquet="debian-archive-keyring"				# Fixe les erreurs de clés GnuPGP
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="foremost"						# Permet de récupérer les éléments supprimés
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gnupg2"						# GNU Privacy Guard
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="gucharmap"					# Table de caractères
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="i7z"						# Permet d'afficher en ligne de commandes les informations sur les cores du CPU ainsi que le mode turbo
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
#	local Paquet="i7z-gui"						# Permet d'afficher graphiquement les informations sur les cores du CPU
#	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
#		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
#		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}"
#	else
#		local CodeRetour=0
#		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
#	fi
	local Paquet="skanlite"						# Logiciel de numérisation
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="testdisk"						# Test de partitions
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="exfat-fuse"					# Permet de lire les cartes formatées exFAT
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="exfat-utils"					# Permet de lire les cartes formatées exFAT
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libtiff5"						# Librairie TIFF
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libxi-dev"					# Permet de debugguer Genymotion
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="libxmu-dev"					# Permet de debugguer Genymotion
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="lm-sensors"					# Permet d'avoir le niveau des sondes de température
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	local Paquet="zram-config"					# Compression de la mémoire RAM
	if [[ $(dpkg -s ${Paquet} 2> '/dev/null' | grep Status | awk '{print $3}' | tr '[:upper:]' '[:lower:]') != "ok" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${Paquet}${CYAN} en cours...${DEFAUT}"
		sudo apt-get install -qq -y ${Paquet}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}"
	else
		local CodeRetour=0
		TestSiErreur ${CodeRetour} "${Paquet}" "ok"
	fi
	:
	## Support AMR/3GP (non fonctionnel pour le moment) ##
	#quilt dpkg-dev libimlib2-dev texi2html libfaad-dev libfaac-dev libxvidcore4-dev debhelper libogg-dev libvorbis-dev liba52-dev libdts-dev libraw1394-dev libtheora-dev libgsm1-dev libx264-dev x264 libxvidcore4
}

# Installations de paquets hors dépôts
function AutresPaquets(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type d'installation
	local DosTmp="/var/tmp"													# Répertoire temporaire
	local FicTmp=""														# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"											# Fichier temporaire de destination
	local Paquet=""														# Paquet à installer
	local Lien=""														# Lien à créer
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Installations d'applications diverses :${DEFAUT}"
	# Google Earth
	local Paquet="https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb"
	local FicTmp="$(echo $(basename ${Paquet}))"			# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"				# Fichier temporaire de destination
	echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
	wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																	2>&0
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "${Paquet}" "wget"
	if [[ -e "${DestTmp}" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
		sudo dpkg -i "${DestTmp}"																			&> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
		if [[ ${CodeRetour} -ne 0 ]]; then
			echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
			sudo apt --fix-broken install -y																	&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
		fi
	else
		local CodeRetour=127
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
	fi
	if [[ -e "${DestTmp}" ]]; then
		rm "${DestTmp}"																								2>&0
	fi
	# Google Talk
	local Paquet="https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb"
	local FicTmp="$(echo $(basename ${Paquet}))"			# Nom du fichier temporaire
	local DestTmp="${DosTmp}/${FicTmp}"				# Fichier temporaire de destination
	echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
	wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																	2>&0
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "${Paquet}" "wget"
	if [[ -e "${DestTmp}" ]]; then
		echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
		sudo dpkg -i "${DestTmp}"																			&> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
		if [[ ${CodeRetour} -ne 0 ]]; then
			echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
			sudo apt --fix-broken install -y																				2>&0
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
		fi
	else
		local CodeRetour=127
		TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
	fi
	if [[ -e "${DestTmp}" ]]; then
		rm "${DestTmp}"																								2>&0
	fi
	if [[ ${Type} == "tout" ]]; then
		# Hubic
		local Paquet="http://mir7.ovh.net/ovh-applications/hubic/hubiC-Linux/2.1.0/hubiC-Linux-2.1.0.53-linux.deb"
		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
		if [[ -e "${DestTmp}" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
			if [[ ${CodeRetour} -ne 0 ]]; then
				sudo apt --fix-broken install	-y																&> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
			fi
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
		fi
		if [[ -e "${DestTmp}" ]]; then
			rm "${DestTmp}"																							2>&0
		fi
		# TeamViewer
		local Paquet="https://download.teamviewer.com/download/linux/teamviewer_amd64.deb"
		local FicTmp="$(echo $(basename ${Paquet}))"		# Nom du fichier temporaire
		local DestTmp="${DosTmp}/${FicTmp}"			# Fichier temporaire de destination
		echo " ${JAUNE}Téléchargement du paquet ${CYAN}${FicTmp}${JAUNE} en cours...${DEFAUT}"
		wget -q "${Paquet}" --show-progress --progress=bar:force -O "${DestTmp}"																2>&0
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Paquet}" "wget"
		if [[ -e "${DestTmp}" ]]; then
			echo " ${CYAN}Installation du paquet ${BLANC}${FicTmp}${CYAN} en cours...${DEFAUT}"
			sudo dpkg -i "${DestTmp}"																		&> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg"
			if [[ ${CodeRetour} -ne 0 ]]; then
				echo " ${JAUNE}Correction des dépendances en cours${DEFAUT}"
				sudo apt --fix-broken install -y																&> '/dev/null'
				local CodeRetour=${?}
				TestSiErreur ${CodeRetour} "${FicTmp}" "fix"
			fi
		else
			local CodeRetour=127
			TestSiErreur ${CodeRetour} "${FicTmp}" "dpkg_absent"
		fi
		if [[ -e "${DestTmp}" ]]; then
			rm "${DestTmp}"																							2>&0
		fi
		:
	fi
	
#		local Paquet="TeamSpeak"
#		sudo chmod -R +rx "/usr/share/${Paquet}*"																	> '/dev/null'
#		local CodeRetour=${?}
#		TestSiErreur ${CodeRetour} "${Paquet}" "${Paquet}"
}

# Attribution des groupes
function AttributionGroupes(){
	# Variables locales
	local Comptes="${LISTE_UTILISATEURS}"											# Liste des comptes utilisateurs
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type de groupe
	local Groupe=""														# Groupe
	local CodeRetour=0													# Code retour
	#
	if [[ -z "${Comptes}" ]]; then
		local Comptes="${UTILISATEUR}"
	fi
	if [[ "${Type}" == "roccat" ]]; then
		local Groupe="roccat"					# Utilisateurs du matériel Roccat
		sudo gpasswd -M ${Comptes} ${Groupe}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Groupe}" "groupe"
	fi
	if [[ "${Type}" == "virtualbox" ]]; then
		local Groupe="vboxusers"				# Utilisateurs du matériel Roccat
		sudo gpasswd -M ${Comptes} ${Groupe}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Groupe}" "groupe"
	fi
	if [[ "${Type}" == "système" ]]; then
		local Groupe="cdrom"					# Utilisateurs du lecteur CD-ROM
		sudo gpasswd -M ${Comptes} ${Groupe}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Groupe}" "groupe"
		local Groupe="floppy"					# Utilisateurs du lecteur disquettes
		sudo gpasswd -M ${Comptes} ${Groupe}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Groupe}" "groupe"
		local Groupe="tape"					# Utilisateur du lecteur cassettes
		sudo gpasswd -M ${Comptes} ${Groupe}																		> '/dev/null'
		local CodeRetour=${?}
		TestSiErreur ${CodeRetour} "${Groupe}" "groupe"
	fi
	:
}

# Dernières mises à jour...
function FinalisationMAJ(){
	# Variables locales
	local Type="$(echo ${1} | tr '[:upper:]' '[:lower:]')"									# Type de mise à jour
	local CodeRetour=0													# Code retour
	#
	echo " ${CYAN}Finalisation et mises à jours...${DEFAUT}"
	echo " ${JAUNE} Correction des dépendences manquantes et installation forcée des paquets...${DEFAUT}"
	sudo apt --fix-broken install																							&> '/dev/null'
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "" "force"
	sudo apt-get install -qq -f -y																				> '/dev/null'	# Permet d'installer les dépendances manquantes
	local CodeRetour=${?}
	TestSiErreur ${CodeRetour} "" "force"
	if [[ "${Type}" != "complet" ]]; then
		if [[ ${CodeRetour} -eq  0 ]]; then
			sudo apt-get update -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
		fi
#		if [[ ${CodeRetour} -eq 0 ]]; then
#			sudo apt-get upgrade -qq -y																		> '/dev/null'
#			local CodeRetour=${?}
#			TestSiErreur ${CodeRetour} "" "maj"
#		fi
	else
		if [[ ${CodeRetour} -eq 0 ]]; then
			sudo apt-get update -qq -f -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
		fi
		if [[ ${CodeRetour} -eq 0 ]]; then
			sudo apt-get upgrade -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj"
		fi
		if [[ ${CodeRetour} -eq 0 ]]; then
			echo " ${JAUNE}Mise à jour du système...${DEFAUT}"
			sudo apt-get dis-upgrade -qq -y																		> '/dev/null'
			local CodeRetour=${?}
			TestSiErreur ${CodeRetour} "" "maj_système"
		fi
		:
	fi
	:
}

# Fin
function AfficherFin(){
	# Variables locales
	local NbErreurs="$(cat ${TEMPORAIRE} | wc -l)"																							2>&0
	local CodeRetour=0													# Code retour
	#
	if [[ ! -e "${TEMPORAIRE}" ]]; then
		echo "${FVERT} ${BLEU}RÉINSTALLATION DES PAQUETS DU SYSTÈME TERMINÉE${DEFAUT}"
		echo
		if [[ -e "${TEMPORAIRE}" ]]; then
			rm "${TEMPORAIRE}"																								2>&0
		fi
		exit ${CodeRetour}
	else
		local CodeRetour=1
		if [[ "${NbErreurs}" -eq 1 ]]; then
			echo "${JAUNE} ${BLEU}RÉINSTALLATION DES PAQUETS DU SYSTÈME TERMINÉE [${ROUGE}${NbErreurs} erreur${BLEU}]${DEFAUT}"
		elif [[ "${NbErreurs}" -gt 1 ]]; then
			echo "${JAUNE} ${BLEU}RÉINSTALLATION DES PAQUETS DU SYSTÈME TERMINÉE [${ROUGE}${NbErreurs} erreurs${BLEU}]${DEFAUT}"
		else
			echo "${JAUNE} ${BLEU}RÉINSTALLATION DES PAQUETS DU SYSTÈME TERMINÉE${DEFAUT}"
		fi
		echo
		if [[ -e "${JOURNALISATION}" ]] && [[ $(cat ${JOURNALISATION} 2> '/dev/null' | wc -l) -gt 0 ]]; then
			echo "${MAGENTA} Voir journal dans ${JOURNALISATION}${DEFAUT}"
		fi
		rm "${TEMPORAIRE}"																									2>&0
		exit ${CodeRetour}
	fi
	if [[ -e "${TEMPORAIRE}" ]]; then
		rm "${TEMPORAIRE}"																									2>&0
	fi
	:
}

# Packages d'installation
function PackageInstallation(){
	local TypeInstallation="$(echo ${1} | tr '[:upper:]' '[:lower:]')"							# Type d'installation
	local CodeRetour=0													# Code retour
	#
	case "${TypeInstallation}" in
		"légé" | "allégé" | "light" )
			PilotesGraphiques
#			PilotesAudio
			if [[ $(lsusb | grep ROCCAT | awk '{print $7}' | uniq | tr '[:lower:]' '[:upper:]')  == "ROCCAT" ]]; then
				PilotesRoccat
			fi
#			PilotesImprimantesSamsung
			PaquetsBureautique "légé"
			PaquetsInternet "légé"
			PaquetsJeux "légé"
			PaquetsMultimedia "légé"
			PaquetsServeurs "légé"
			PaquetsSecurite "légé"
			PaquetsUtilitaires "légé"
#			AutresPaquets "légé"
			AttributionGroupes "système"
			FinalisationMAJ
			;;
		"normal" )
			PilotesGraphiques
#			PilotesAudio
			if [[ $(lsusb | grep ROCCAT | awk '{print $7}' | uniq | tr '[:lower:]' '[:upper:]')  == "ROCCAT" ]]; then
				PilotesRoccat
			fi
			PilotesImprimantesSamsung
			PaquetsBureautique "normal"
			PaquetsCompression "normal"
			PaquetsDeveloppement "normal"
			PaquetsCompilation "normal"
			PaquetsInternet "normal"
			PaquetsJeux "normal"
			PaquetsMultimedia "normal"
			PaquetsServeurs "normal"
			PaquetsSecurite "normal"
			PaquetsUtilitaires "normal"
			AutresPaquets "normal"
			AttributionGroupes "système"
			FinalisationMAJ "normal"
			;;
		"complet" | "full" )
			PilotesGraphiques
#			PilotesAudio
			if [[ $(lsusb | grep ROCCAT | awk '{print $7}' | uniq | tr '[:lower:]' '[:upper:]')  == "ROCCAT" ]]; then
				PilotesRoccat
			fi
			PilotesImprimantesSamsung
			PaquetsBureautique "tout"
			PaquetsCompression "tout"
			PaquetsDeveloppement "tout"
			PaquetsCompilation "tout"
			PaquetsInternet "tout"
			PaquetsJeux "tout"
			PaquetsMultimedia "tout"
			PaquetsServeurs "tout"
			PaquetsSecurite "tout"
			PaquetsUtilitaires "tout"
			AutresPaquets "tout"
			AttributionGroupes "système"
			FinalisationMAJ "normal"
			;;
		"complet-maj" | "full-upgrade" )
			PilotesGraphiques
#			PilotesAudio
			if [[ $(lsusb | grep ROCCAT | awk '{print $7}' | uniq | tr '[:lower:]' '[:upper:]')  == "ROCCAT" ]]; then
				PilotesRoccat
			fi
			PilotesImprimantesSamsung
			PaquetsBureautique "tout"
			PaquetsCompression "tout"
			PaquetsDeveloppement "tout"
			PaquetsCompilation "tout"
			PaquetsInternet "tout"
			PaquetsJeux "tout"
			PaquetsMultimedia "tout"
			PaquetsServeurs "tout"
			PaquetsSecurite "tout"
			PaquetsUtilitaires "tout"
			AutresPaquets "tout"
			AttributionGroupes "système"
			FinalisationMAJ "complet"
			;;
		* )
			if [[ ! -z "${TypeInstallation}" ]]; then
				echo " ${ROUGE}Appel de fonction inconnue [${JAUNE}${TypeInstallation}${ROUGE}]${DEFAUT}"
			else
				echo " ${ROUGE}Appel de fonction inconnue${DEFAUT}"
			fi
			exit 20
			:
			;;
	esac
}

# Actions sur choix de l'interface
function ChoixInterface(){
	local Choix=""														# Choix de l'utilisateur
	local Validation=0													# Validation du choix
	local CodeRetour=0													# Code retour
	#
	echo "${FBLEU} ${JAUNE}MENU${DEFAUT}"
	echo "${BLANC}[${BLEU}0${BLANC}]    Installation légère (basique)${DEFAUT}"
	echo "${BLANC}[${BLEU}1${BLANC}]    Installation normale${DEFAUT}"
	echo "${BLANC}[${BLEU}2${BLANC}]    Installation complète${DEFAUT}"
	echo "${BLANC}[${BLEU}3${BLANC}]    Installation complète et migration${DEFAUT}"
	echo "${BLANC}[${BLEU}4${BLANC}]    Installation de pilotes${DEFAUT}"
	echo "${BLANC}[${BLEU}5${BLANC}]    Installation des paquets pour les applications bureautiques${DEFAUT}"
	echo "${BLANC}[${BLEU}6${BLANC}]    Installation des outils de compression${DEFAUT}"
	echo "${BLANC}[${BLEU}7${BLANC}]    Installation des paquets pour développeur${DEFAUT}"
	echo "${BLANC}[${BLEU}8${BLANC}]    Installation des paquets pour Internet${DEFAUT}"
	echo "${BLANC}[${BLEU}9${BLANC}]    Installation des jeux-vidéos et autres paquets associés${DEFAUT}"
	echo "${BLANC}[${BLEU}10${BLANC}]   Installation des paquets multimédia${DEFAUT}"
	echo "${BLANC}[${BLEU}11${BLANC}]   Installation des paquets serveur${DEFAUT}"
	echo "${BLANC}[${BLEU}12${BLANC}]   Installation des paquets de securité${DEFAUT}"
	echo "${BLANC}[${BLEU}13${BLANC}]   Installation des paquets utilitaires${DEFAUT}"
	echo "${BLANC}[${BLEU}14${BLANC}]   Autres paquets (hors dépôts)...${DEFAUT}"
	echo "${ROUGE}[${BLEU}Q${ROUGE}]    Quitter${DEFAUT}"
	echo
	echo "${BLANC}[${MAGENTA}?${BLANC}]    Aide${DEFAUT}"
	echo
	while [[ ${Validation} -eq 0 ]]; do
		read -r -p " ${MAGENTA}Votre choix ?${DEFAUT} " Choix
		local Choix=$(echo ${Choix} | tr '[:upper:]' '[:lower:]')
		case "${Choix}" in
			0 | "légé" | "light" )
				echo
				local Validation=1
				PackageInstallation "légé"
				AfficherFin
				;;
			1 | "normal" )
				echo
				local Validation=1
				PackageInstallation "normal"
				AfficherFin
				;;
			2 | "complet" | "full" )
				echo
				local Validation=1
				PackageInstallation "complet"
				AfficherFin
				;;
			3 | "graphique" | "graphics" )
				echo
				local Validation=1
				PackageInstallation "complet-maj"
				AfficherFin
				;;
			4 | "pilotes" | "drivers" )
				echo
				local Validation=1
				PilotesGraphiques
				if [[ $(lsusb | grep ROCCAT | awk '{print $7}' | uniq | tr '[:lower:]' '[:upper:]')  == "ROCCAT" ]]; then
					PilotesRoccat
				fi
#				PilotesAudio
				PilotesImprimantesSamsung
				AfficherFin
				;;
			5 | "bureautique" )
				echo
				local Validation=1
				PaquetsBureautique "tout"
				AfficherFin
				;;
			6 | "compression" )
				echo
				local Validation=1
				PaquetsCompression "tout"
				AfficherFin
				;;
			7 | "développement" | "dev" )
				echo
				local Validation=1
				PaquetsDeveloppement "tout"
				PaquetsCompilation "tout"
				AfficherFin
				;;
			8 | "internet" )
				echo
				local Validation=1
				PaquetsInternet "tout"
				AfficherFin
				;;
			9 | "jeux" | "jeux-vidéo" )
				echo
				local Validation=1
				PilotesGraphiques
				PaquetsJeux "tout"
				AfficherFin
				;;
			10 | "multimédia" | "multimedia" )
				echo
				local Validation=1
				PaquetsMultimedia "tout"
				AfficherFin
				;;
			11 | "serveur" )
				echo
				local Validation=1
				PaquetsServeurs "tout"
				AfficherFin
				;;
			12 | "sécurité" )
				echo
				local Validation=1
				PaquetsSecurite "tout"
				AfficherFin
				;;
			13 | "utilitaires" )
				echo
				local Validation=1
				PaquetsUtilitaires "tout"
				AfficherFin
				;;
			14 | "autres" )
				echo
				local Validation=1
				AutresPaquets "tout"
				AfficherFin
				;;
			"q" | "quitter" )
				echo
				local Validation=1
				if [[ -e "${TEMPORAIRE}" ]]; then
					rm "${TEMPORAIRE}"																								2>&0
				fi
				echo " ${MAGENTA}Au revoir !${DEFAUT}"
				;;
			"?" | "aide" | "help" )
				local Validation=1
				Usage "manuel"
				:
				;;
			* )
				echo
				echo " ${JAUNE}Choix invalide${DEFAUT}"
				echo " ${JAUNE}Sélectionnez une option de la liste ou entrez ${MAGENTA}? ${JAUNE}pour afficher l'aide${DEFAUT}"
				;;
		esac
	done
}

# Installation
function InstallerPaquets(){
	# Variables locales
	local Paquet=""														# Paquet à installer
	local TypeInstallation="$(echo ${1} | tr '[:upper:]' '[:lower:]')"							# Type d'installation
	local CodeRetour=0													# Code retour
	#
	case "${TypeInstallation}" in
		"interface" )
			ChoixInterface
			if [[ -e "${TEMPORAIRE}" ]]; then
				rm "${TEMPORAIRE}"																									2>&0
			fi
			echo
			exit 0
			;;
		"légé" | "allégé" | "light" )
			PackageInstallation "légé"
			;;
		"normal" )
			PackageInstallation "normal"
			;;
		"complet" | "full" )
			PackageInstallation "complet"
			;;
		"complet-maj" | "full-upgrade" )
			PackageInstallation "complet-maj"
			;;
		"graphique" )
			PilotesGraphiques
			;;
#		"audio" )
#			PilotesAudio
#			;;
		"roccat" )
			PilotesRoccat
			;;
		"samsung" )
			PilotesImprimantesSamsung
			;;
		"bureautique" )
			PaquetsBureautique " tout"
			;;
		"compression" )
			PaquetsCompression "tout"
			;;
		"developpement" )
			PaquetsDeveloppement "tout"
			;;
		"compilation" )
			PaquetsCompilation "tout"
			;;
		"internet" )
			PaquetsInternet "tout"
			;;
		"jeux" | "jeux-vidéo" )
			PaquetsJeux "tout"
			;;
		"multimédia" | "multimedia" )
			PaquetsMultimedia "tout"
			;;
		"serveur" )
			PaquetsServeurs "tout"
			;;
		"sécurité" )
			PaquetsSecurite "tout"
			;;
		"utilitaires" )
			PaquetsUtilitaires "tout"
			;;
		"autres" )
			AutresPaquets "tout"
			;;
		* )
			if [[ ! -z "${TypeInstallation}" ]]; then
				echo " ${ROUGE}Appel de fonction inconnue [${JAUNE}${TypeInstallation}${ROUGE}]${DEFAUT}"
			else
				echo " ${ROUGE}Appel de fonction inconnue${DEFAUT}"
			fi
			:
			exit 20
			;;
	esac
	:
}

## DÉBUT ##
if [[ ${NBPARAMS} -gt 0 ]]; then
	TestParametres ${PARAMS}
else
	if [[ ${UAV} -ne 1 ]]; then
		AfficherTitre "${VERSION}"
	fi
	TestUtilisateur
	InstallerPaquets "interface"
fi

## FIN ##
if [[ ${UAV} -ne 1 ]]; then
	AfficherFin
fi
